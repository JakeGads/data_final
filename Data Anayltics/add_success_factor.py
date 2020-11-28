"""
ID,name,category,main_category,currency,deadline,goal,launched,pledged,state,backers,country,usd_pledged,usd_pledged_real,usd_goal_real
"""

class Row:
    def __init__(self, entry):
        self.ID =entry[0]
        self.name =entry[1]
        self.category =entry[2]
        self.main_category =entry[3]
        self.currency =entry[4]
        self.deadline =entry[5]
        self.goal =entry[6]
        self.launched =entry[7]
        self.pledged =entry[8]
        self.state =entry[9]
        self.backers =entry[10]
        self.country =entry[11]
        self.usd_pledged =entry[12]
        self.usd_pledged_real=""
        self.usd_goal_real = ""
        self.success_factor = ""
        
        try:
            self.usd_pledged_real=float(entry[13])
            self.usd_goal_real =float(entry[14][:-1])
        except Exception:
            self.usd_pledged_real=entry[13]
            self.usd_goal_real =entry[14][:-1]
        try:
            self.success_factor = (self.usd_pledged_real+1) / (1+self.usd_goal_real)
        except Exception:
            self.success_factor = "success_factor"

    def __repr__(self):
        return f'{self.ID},{self.name},{self.category},{self.main_category},{self.currency},{self.deadline},{self.goal},{self.launched},{self.pledged},{self.state},{self.backers},{self.country},{self.usd_pledged},{self.usd_pledged_real},{self.usd_goal_real},{self.success_factor}\n'

with open("clean_ks.csv", "r") as in_file:
    with open("clean_ks_app.csv", "w+") as out_file:
        for i in in_file.readlines():
            try:
                out_file.write(Row(i.split(",")).__repr__())
                
            except Exception:
                print(i)