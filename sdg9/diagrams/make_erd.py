"""Draws the ERD for the SDG 9 school technology database (updated design).
Run: python3 make_erd.py   ->  ERD.png, ERD.pdf
Tables match sql/01_create_tables.sql: schools, surveys, survey_issues,
issues, needs, plus the school_needs_summary view.
"""
import cairosvg

BLUE, ORANGE, INK, GREY, LINE, VIEWC = '#2b5797', '#b85c00', '#1a1a1a', '#555555', '#3a3a3a', '#6b6b6b'
HEAD, ROW = 40, 30

tables = {
    # name: (x, y, width, color, [(key, column, type), ...])
    'schools': (40, 100, 400, BLUE, [
        ('PK', 'school_id', 'INT'),
        ('', 'school_name', 'VARCHAR(100)'),
        ('', 'location', 'VARCHAR(100)'),
        ('', 'students', 'INT'),
        ('', 'devices', 'INT'),
        ('', 'device_age', 'DECIMAL(3,1)'),
        ('', 'internet_speed', 'INT'),
        ('', 'budget', 'INT'),
    ]),
    'surveys': (540, 100, 330, BLUE, [
        ('PK', 'survey_id', 'INT'),
        ('FK', 'school_id', 'INT'),
        ('', 'role', 'VARCHAR(20)'),
        ('', 'wifi_works', 'VARCHAR(3)'),
        ('', 'survey_date', 'DATE'),
    ]),
    'survey_issues': (540, 400, 330, ORANGE, [
        ('PK, FK', 'survey_id', 'INT'),
        ('PK, FK', 'issue_id', 'INT'),
    ]),
    'issues': (980, 100, 340, BLUE, [
        ('PK', 'issue_id', 'INT'),
        ('', 'issue_name', 'VARCHAR(50)'),
        ('FK', 'need_id', 'INT'),
    ]),
    'needs': (980, 400, 340, BLUE, [
        ('PK', 'need_id', 'INT'),
        ('', 'need_name', 'VARCHAR(50)'),
    ]),
}

view = ('school_needs_summary', 40, 450, 400, [
    'school_id', 'school_name', 'need_id', 'need_name', 'times_reported', 'surveys_reporting',
])

KEYW = 66  # room for the key column


def row_y(name, i):
    x, y, w, c, cols = tables[name]
    return y + HEAD + ROW * i + ROW / 2


def box(name):
    x, y, w, c, cols = tables[name]
    h = HEAD + ROW * len(cols) + 6
    title = name + ('  (junction table)' if name == 'survey_issues' else '')
    s = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" fill="white" stroke="{c}" stroke-width="2"/>',
         f'<path d="M{x} {y + HEAD} V{y + 6} a6 6 0 0 1 6 -6 H{x + w - 6} a6 6 0 0 1 6 6 V{y + HEAD} Z" fill="{c}"/>',
         f'<text x="{x + w / 2}" y="{y + 26}" text-anchor="middle" font-size="17" font-weight="700" fill="white">{title}</text>']
    for i, (k, col, typ) in enumerate(cols):
        cy = row_y(name, i) + 5
        if k:
            s.append(f'<text x="{x + 12}" y="{cy}" font-size="13" font-weight="700" fill="{c}">{k}</text>')
        s.append(f'<text x="{x + KEYW}" y="{cy}" font-size="15" fill="{INK}">{col}</text>')
        s.append(f'<text x="{x + w - 12}" y="{cy}" text-anchor="end" font-size="14" fill="{GREY}">{typ}</text>')
        if i < len(cols) - 1:
            ly = y + HEAD + ROW * (i + 1)
            s.append(f'<line x1="{x + 8}" x2="{x + w - 8}" y1="{ly}" y2="{ly}" stroke="#e3e3e3"/>')
    return s


def view_box():
    name, x, y, w, cols = view
    h = HEAD + ROW * len(cols) + 6
    s = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" fill="#fafafa" stroke="{VIEWC}" stroke-width="2" stroke-dasharray="7 5"/>',
         f'<text x="{x + w / 2}" y="{y + 26}" text-anchor="middle" font-size="17" font-weight="700" fill="{VIEWC}">{name}  (VIEW)</text>',
         f'<line x1="{x + 8}" x2="{x + w - 8}" y1="{y + HEAD}" y2="{y + HEAD}" stroke="{VIEWC}" stroke-dasharray="4 4"/>']
    for i, col in enumerate(cols):
        cy = y + HEAD + ROW * i + ROW / 2 + 5
        s.append(f'<text x="{x + KEYW}" y="{cy}" font-size="15" fill="{GREY}">{col}</text>')
    s.append(f'<text x="{x}" y="{y + h + 22}" font-size="13" fill="{GREY}">Calculated, not stored: surveys → survey_issues → issues → needs.</text>')
    s.append(f'<text x="{x}" y="{y + h + 40}" font-size="13" fill="{GREY}">Replaces the old SchoolNeeds table.</text>')
    return s


def one(x, y, d, vertical=False):
    """two bars = exactly one; d points from the line into the box"""
    out = []
    for off in (10, 16):
        if vertical:
            yy = y - d * off
            out.append(f'<line x1="{x - 8}" x2="{x + 8}" y1="{yy}" y2="{yy}" stroke="{LINE}" stroke-width="2"/>')
        else:
            xx = x - d * off
            out.append(f'<line x1="{xx}" x2="{xx}" y1="{y - 8}" y2="{y + 8}" stroke="{LINE}" stroke-width="2"/>')
    return out


def many(x, y, d, vertical=False):
    """crow's foot (+ bar = one or more); toes touch the box edge"""
    if vertical:
        b = y - d * 16
        return [f'<path d="M{x} {b} L{x - 9} {y} M{x} {b} L{x} {y} M{x} {b} L{x + 9} {y}" stroke="{LINE}" stroke-width="2" fill="none"/>',
                f'<line x1="{x - 8}" x2="{x + 8}" y1="{y - d * 22}" y2="{y - d * 22}" stroke="{LINE}" stroke-width="2"/>']
    b = x - d * 16
    return [f'<path d="M{b} {y} L{x} {y - 9} M{b} {y} L{x} {y} M{b} {y} L{x} {y + 9}" stroke="{LINE}" stroke-width="2" fill="none"/>',
            f'<line x1="{x - d * 22}" x2="{x - d * 22}" y1="{y - 8}" y2="{y + 8}" stroke="{LINE}" stroke-width="2"/>']


def label(x, y, text, anchor='middle'):
    return [f'<text x="{x}" y="{y}" text-anchor="{anchor}" font-size="13" fill="{GREY}">{text}</text>']


def right(n):
    x, y, w, c, cols = tables[n]; return x + w


def left(n):
    return tables[n][0]


def top(n):
    return tables[n][1]


def bottom(n):
    x, y, w, c, cols = tables[n]; return y + HEAD + ROW * len(cols) + 6


parts = []
# schools -> surveys (one school, many surveys), straight at surveys.school_id
y1 = row_y('surveys', 1)
parts += [f'<line x1="{right("schools")}" x2="{left("surveys")}" y1="{y1}" y2="{y1}" stroke="{LINE}" stroke-width="2"/>']
parts += one(right('schools'), y1, -1) + many(left('surveys'), y1, 1)
parts += label((right('schools') + left('surveys')) / 2, y1 - 10, '1 : many')

# surveys -> survey_issues (vertical)
xv = left('surveys') + 165
yt, yb = bottom('surveys'), top('survey_issues')
parts += [f'<line x1="{xv}" x2="{xv}" y1="{yt}" y2="{yb}" stroke="{LINE}" stroke-width="2"/>']
parts += one(xv, yt, -1, vertical=True) + many(xv, yb, 1, vertical=True)
parts += label(xv + 12, (yt + yb) / 2 + 4, '1 : many', 'start')

# issues -> survey_issues (elbow), from issues.issue_id to survey_issues.issue_id
ya, yb3, xm = row_y('issues', 0), row_y('survey_issues', 1), 925
parts += [f'<path d="M{left("issues")} {ya} H{xm} V{yb3} H{right("survey_issues")}" stroke="{LINE}" stroke-width="2" fill="none"/>']
parts += one(left('issues'), ya, 1) + many(right('survey_issues'), yb3, -1)
parts += label(xm - 8, (ya + yb3) / 2 + 4, '1 : many', 'end')

# needs -> issues (vertical): one need, many issues
xv2 = left('issues') + 170
yt2, yb4 = top('needs'), bottom('issues')
parts += [f'<line x1="{xv2}" x2="{xv2}" y1="{yt2}" y2="{yb4}" stroke="{LINE}" stroke-width="2"/>']
parts += one(xv2, yt2, 1, vertical=True) + many(xv2, yb4, -1, vertical=True)
parts += label(xv2 + 12, (yt2 + yb4) / 2 + 4, '1 : many', 'start')

# many-to-many note under the junction table
mx = left('survey_issues')
my = bottom('survey_issues') + 24
parts += label(mx, my, 'surveys ↔ issues is many-to-many:', 'start')
parts += label(mx, my + 18, 'one survey can report several issues,', 'start')
parts += label(mx, my + 36, 'one issue can appear on many surveys.', 'start')

for n in tables:
    parts += box(n)
parts += view_box()

W, H = 1360, 800
legend_y = 760
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" font-family="Inter, DejaVu Sans, Arial, sans-serif">
<rect width="{W}" height="{H}" fill="white"/>
<text x="40" y="44" font-size="24" font-weight="700" fill="{INK}">SDG 9 School Technology Database: Entity Relationship Diagram</text>
<text x="40" y="72" font-size="15" fill="{GREY}">MySQL 8 · 5 tables + 1 view · PK = primary key, FK = foreign key · database: sdg9_school_tech</text>
{chr(10).join(parts)}
<g font-size="14" fill="{INK}">
  {''.join(one(70, legend_y, 1))}<line x1="44" x2="70" y1="{legend_y}" y2="{legend_y}" stroke="{LINE}" stroke-width="2"/>
  <text x="82" y="{legend_y + 5}">exactly one</text>
  {''.join(many(230, legend_y, 1))}<line x1="200" x2="230" y1="{legend_y}" y2="{legend_y}" stroke="{LINE}" stroke-width="2"/>
  <text x="242" y="{legend_y + 5}">one or many</text>
  <rect x="380" y="{legend_y - 9}" width="18" height="18" rx="3" fill="{ORANGE}"/>
  <text x="408" y="{legend_y + 5}">junction table</text>
  <rect x="540" y="{legend_y - 9}" width="18" height="18" rx="3" fill="#fafafa" stroke="{VIEWC}" stroke-width="2" stroke-dasharray="4 3"/>
  <text x="568" y="{legend_y + 5}">view (calculated from the tables, not stored)</text>
</g>
</svg>'''

cairosvg.svg2png(bytestring=svg.encode(), write_to='ERD.png', scale=2)
cairosvg.svg2pdf(bytestring=svg.encode(), write_to='ERD.pdf')
print('ok')
