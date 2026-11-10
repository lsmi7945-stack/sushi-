"""Draws the ERD for the SDG 9 school technology database.
Run: python3 make_erd.py   ->  ERD.svg, ERD.png, ERD.pdf
"""
import cairosvg

BLUE, ORANGE, INK, GREY, LINE = '#2b5797', '#b85c00', '#1a1a1a', '#555555', '#3a3a3a'
HEAD, ROW = 40, 30

tables = {
    # name: (x, y, width, color, [(key, column, type), ...])
    'Schools': (40, 100, 420, BLUE, [
        ('PK', 'SchoolID', 'INT'),
        ('', 'SchoolName', 'VARCHAR(100)'),
        ('', 'Location', 'VARCHAR(100)'),
        ('', 'Students', 'INT'),
        ('', 'Devices', 'INT'),
        ('', 'StudentsPerDevice', 'DECIMAL(3,1)'),
        ('', 'DeviceAge', 'DECIMAL(3,1)'),
        ('', 'InternetSpeed', 'INT'),
        ('', 'WiFiProblems', 'INT'),
        ('', 'Budget', 'INT'),
    ]),
    'Surveys': (540, 100, 320, BLUE, [
        ('PK', 'SurveyID', 'INT'),
        ('FK', 'SchoolID', 'INT'),
        ('', 'Role', 'VARCHAR(20)'),
        ('FK', 'IssueID', 'INT'),
        ('', 'WiFiWorks', 'VARCHAR(3)'),
        ('', 'SurveyDate', 'DATE'),
    ]),
    'SchoolNeeds': (540, 360, 320, ORANGE, [
        ('PK', 'SchoolNeedID', 'INT'),
        ('FK', 'SchoolID', 'INT'),
        ('FK', 'NeedID', 'INT'),
        ('', 'Priority', 'INT'),
    ]),
    'Issues': (1000, 100, 320, BLUE, [
        ('PK', 'IssueID', 'INT'),
        ('', 'IssueName', 'VARCHAR(50)'),
        ('FK', 'NeedID', 'INT'),
    ]),
    'Needs': (1000, 360, 320, BLUE, [
        ('PK', 'NeedID', 'INT'),
        ('', 'NeedName', 'VARCHAR(50)'),
    ]),
}

def row_y(name, i):
    x, y, w, c, cols = tables[name]
    return y + HEAD + ROW * i + ROW / 2

def box(name):
    x, y, w, c, cols = tables[name]
    h = HEAD + ROW * len(cols) + 6
    title = name + ('  (junction table)' if name == 'SchoolNeeds' else '')
    s = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" fill="white" stroke="{c}" stroke-width="2"/>',
         f'<path d="M{x} {y + HEAD} V{y + 6} a6 6 0 0 1 6 -6 H{x + w - 6} a6 6 0 0 1 6 6 V{y + HEAD} Z" fill="{c}"/>',
         f'<text x="{x + w / 2}" y="{y + 26}" text-anchor="middle" font-size="17" font-weight="700" fill="white">{title}</text>']
    for i, (k, col, typ) in enumerate(cols):
        cy = row_y(name, i) + 5
        if k:
            s.append(f'<text x="{x + 12}" y="{cy}" font-size="14" font-weight="700" fill="{c}">{k}</text>')
        s.append(f'<text x="{x + 44}" y="{cy}" font-size="15" fill="{INK}">{col}</text>')
        s.append(f'<text x="{x + w - 12}" y="{cy}" text-anchor="end" font-size="14" fill="{GREY}">{typ}</text>')
        if i < len(cols) - 1:
            ly = y + HEAD + ROW * (i + 1)
            s.append(f'<line x1="{x + 8}" x2="{x + w - 8}" y1="{ly}" y2="{ly}" stroke="#e3e3e3"/>')
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

def bottom(n):
    x, y, w, c, cols = tables[n]; return y + HEAD + ROW * len(cols) + 6

parts = []
# Schools -> SurveyResponses (straight, at SR.SchoolID row)
y1 = row_y('Surveys', 1)
parts += [f'<line x1="{right("Schools")}" x2="{left("Surveys")}" y1="{y1}" y2="{y1}" stroke="{LINE}" stroke-width="2"/>']
parts += one(right('Schools'), y1, -1) + many(left('Surveys'), y1, 1)
parts += label((right('Schools') + left('Surveys')) / 2, y1 - 10, '1 : many')

# Schools -> SchoolNeeds (straight, at SN.SchoolID row)
y2 = row_y('SchoolNeeds', 1)
parts += [f'<line x1="{right("Schools")}" x2="{left("SchoolNeeds")}" y1="{y2}" y2="{y2}" stroke="{LINE}" stroke-width="2"/>']
parts += one(right('Schools'), y2, -1) + many(left('SchoolNeeds'), y2, 1)
parts += label((right('Schools') + left('SchoolNeeds')) / 2, y2 - 10, '1 : many')

# TechnologyIssues -> SurveyResponses (elbow)
ya, yb, xm = row_y('Issues', 0), row_y('Surveys', 3), 945
parts += [f'<path d="M{left("Issues")} {ya} H{xm} V{yb} H{right("Surveys")}" stroke="{LINE}" stroke-width="2" fill="none"/>']
parts += one(left('Issues'), ya, 1) + many(right('Surveys'), yb, -1)
parts += label(xm - 8, (ya + yb) / 2 + 4, '1 : many', 'end')

# TechnologyNeeds -> SchoolNeeds (elbow)
ya, yb = row_y('Needs', 0), row_y('SchoolNeeds', 2)
parts += [f'<path d="M{left("Needs")} {ya} H{xm} V{yb} H{right("SchoolNeeds")}" stroke="{LINE}" stroke-width="2" fill="none"/>']
parts += one(left('Needs'), ya, 1) + many(right('SchoolNeeds'), yb, -1)
parts += label(xm - 8, (ya + yb) / 2 + 4, '1 : many', 'end')

# TechnologyNeeds -> TechnologyIssues (vertical)
xv = tables['Issues'][0] + 160
yt, yb2 = tables['Needs'][1], bottom('Issues')
parts += [f'<line x1="{xv}" x2="{xv}" y1="{yt}" y2="{yb2}" stroke="{LINE}" stroke-width="2"/>']
parts += one(xv, yt, 1, vertical=True) + many(xv, yb2, -1, vertical=True)
parts += label(xv + 12, (yt + yb2) / 2 + 4, '1 : many', 'start')

for n in tables:
    parts += box(n)

W, H = 1360, 620
legend_y = 578
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" font-family="Inter, DejaVu Sans, Arial, sans-serif">
<rect width="{W}" height="{H}" fill="white"/>
<text x="40" y="44" font-size="24" font-weight="700" fill="{INK}">SDG 9 School Technology Database: Entity Relationship Diagram</text>
<text x="40" y="72" font-size="15" fill="{GREY}">MySQL 8.0 · 5 tables · PK = primary key, FK = foreign key</text>
{chr(10).join(parts)}
<g font-size="14" fill="{INK}">
  {''.join(one(70, legend_y, 1))}<line x1="44" x2="70" y1="{legend_y}" y2="{legend_y}" stroke="{LINE}" stroke-width="2"/>
  <text x="82" y="{legend_y + 5}">exactly one</text>
  {''.join(many(230, legend_y, 1))}<line x1="200" x2="230" y1="{legend_y}" y2="{legend_y}" stroke="{LINE}" stroke-width="2"/>
  <text x="242" y="{legend_y + 5}">one or many</text>
  <rect x="380" y="{legend_y - 9}" width="18" height="18" rx="3" fill="{ORANGE}"/>
  <text x="408" y="{legend_y + 5}">SchoolNeeds is the junction table for the many-to-many between Schools and Needs</text>
</g>
</svg>'''


cairosvg.svg2png(bytestring=svg.encode(), write_to='ERD.png', scale=2)
cairosvg.svg2pdf(bytestring=svg.encode(), write_to='ERD.pdf')
print('ok')
