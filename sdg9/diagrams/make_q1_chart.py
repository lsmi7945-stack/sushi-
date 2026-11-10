"""Q1 chart: which improvements schools need most (mock data).
Numbers are the output of Q1 in sql/03_queries.sql."""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

needs = ['New computers', 'Better Wi-Fi', 'Smartboards', 'More IT support',
         'Computer labs', 'Faster internet', 'Tablets']
first  = [6, 3, 2, 1, 2, 0, 1]
second = [2, 4, 3, 3, 1, 2, 0]
third  = [1, 3, 1, 4, 0, 3, 3]
score = [3*a + 2*b + c for a, b, c in zip(first, second, third)]

plt.rcParams['font.family'] = ['Inter', 'DejaVu Sans']
fig, ax = plt.subplots(figsize=(10, 5.2), dpi=200)
y = range(len(needs))[::-1]
blue = '#2b5797'
for vals, left, alpha, lab in [(first, [0]*7, 1.0, '1st choice'),
                               (second, first, 0.6, '2nd choice'),
                               (third, [a+b for a, b in zip(first, second)], 0.25, '3rd choice')]:
    bars = ax.barh(list(y), vals, left=left, color=blue, alpha=alpha, label=lab, height=0.62, edgecolor='white')
    for b, v, l in zip(bars, vals, left):
        if v:
            ax.text(l + v/2, b.get_y() + b.get_height()/2, str(v), ha='center', va='center',
                    fontsize=10, color='white' if alpha > 0.5 else '#1a1a1a')
totals = [a+b+c for a, b, c in zip(first, second, third)]
for yy, t, s in zip(y, totals, score):
    ax.text(t + 0.15, yy, f'score {s}', va='center', fontsize=10, color='#444444')
ax.set_yticks(list(y)); ax.set_yticklabels(needs, fontsize=11)
ax.set_xlim(0, 11.5); ax.set_xlabel('Number of schools that ranked it (of 15)')
for s in ['top', 'right']: ax.spines[s].set_visible(False)
ax.legend(loc='lower right', frameon=False, ncol=3)
fig.suptitle('Q1: New computers is the most-needed fix (ranked 1st by 6 of 15 schools)',
             x=0.02, ha='left', fontsize=14, fontweight='bold')
ax.set_title('Score = 3 points for a 1st choice, 2 for 2nd, 1 for 3rd. Mock data.', loc='left', fontsize=10, color='#555555')
fig.tight_layout()
fig.savefig('Q1_needs_ranking.png'); fig.savefig('Q1_needs_ranking.pdf')
print('ok')
