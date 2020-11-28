"""
ID,name,category,main_category,currency,deadline,goal,launched,pledged,state,backers,country,usd_pledged,usd_pledged_real,usd_goal_real
"""

class Row:
    def __init__(self, ID,name,category,main_category,currency,deadline,goal,launched,pledged,state,backers,country,usd_pledged,usd_pledged_real,usd_goal_real):
        self.ID = ID
        self.name = name
        self.category = category
        self.main_category = main_category
        self.currency = currency
        self.deadline = deadline
        self.goal = goal
        self.launched = launched
        self.pledged = pledged
        self.state = state
        self.backers = backers
        self.country = country
        self.usd_pledged = usd_pledged
        self.usd_pledged_real = usd_pledged_real
        self.usd_goal_real = usd_goal_real
        try:
            self.success_factor = usd_pledged_real / usd_goal_real
        

    def __repr__():
        return '{self.ID},{self.name},{self.category},{self.main_category},{self.currency},{self.deadline},{self.goal},{self.launched},{self.pledged},{self.state},{self.backers},{self.country},{self.usd_pledged},{self.usd_pledged_real},{self.usd_goal_real}{self.sucess_factor}'