import os
import webbrowser

subdirs = sorted([x[0] for x in os.walk('.')])
filtered = []
for i in subdirs:
    if "./_" in i:
        filtered.append(i)

for i in filtered:
    with open(f"{i}/zindex.md", "w+") as file:
        with open(f"{i}/zindex.html", "w+") as html:
            for j in os.walk(i):
                for h in j:
                    for e in h:
                        if ".svg" in e:
                            file.write(f'![]({e})\n<br>\n<div style="page-break-after: always;"></div>\n')    
                            html.write(f'<img src="{e}"><br><br>---------------------------------------------------------------------------------------------------------------------------------<br>')