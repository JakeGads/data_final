import glob
# Open the files that have to be merged one by one
files = glob.glob('*.md')

while("ReadMe.md" in files):
    files.remove("ReadMe.md")

files.sort()

with open("../ReadMe.md", "w+") as w:
    for i in files:
        with open(i, 'r') as r:
            w.write('# KickStater Data')
            for h in r.readlines():
                if h.startswith('#'):
                    h = '\n#' + h
                w.write(h)
            w.write('\n\n<div style="page-break-after: always;"></div>\n\n')