import os
subdirs = sorted([x[0] for x in os.walk('.')])
filtered = []
for i in subdirs:
    if "./_" in i:
        filtered.append(i)

for i in filtered:
    with open(f"{i}/index.html", "w+") as file:
        file.write("""
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Some Graphs</title>
</head>
<body>
""")
        for j in os.walk(i):
            for h in j:
                for e in h:
                    if ".png" in e:
                        file.write(f'<img src="{e}">\n<br>\n')    
        file.write("</body>")
