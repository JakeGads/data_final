# KickStarter Data Proposal | Jake Gadaleta

Over the years Crowdfunding has been more and more popular decision for small business owners. It enables smaller companies and teams to gain the initial capital required to launch a niche product however figuring out when the best time to realise a project can be critical on it's ability to reach the market. In the wake of COVID-19 crowdfunding has a chance to skyrocket once again as people will begin to purchase niche items while the economy repairs itself.

Because of this I would like to attempt to find which types of products preform the best on KickStarter and what the optimal time to announce these projects would be. So the general question is:

<!--Check on this-->
H<sub>0</sub>: Categorical<sub>n</sub>'s R<sup>2</sup> == Categorical<sub>n+1</sub>'s R<sup>2</sup> == Categorical<sub>n-1</sub>'s R<sup>2</sup>

H<sub>1</sub>: Categorical<sub>n</sub>'s R<sup>2</sup> != Categorical<sub>n+1</sub>'s R<sup>2</sup> != Categorical<sub>n-1</sub>'s R<sup>2</sup>

and

H<sub>0</sub>: Date Launched<sub>n</sub>'s R<sup>2</sup> ==
Date Launched<sub>n+1</sub>'s R<sup>2</sup> == 
Date Launched<sub>n-1</sub>'s R<sup>2</sup>

H<sub>1</sub>: Date Launched<sub>n</sub>'s R<sup>2</sup> !=
Date Launched<sub>n+1</sub>'s R<sup>2</sup> != 
Date Launched<sub>n-1</sub>'s R<sup>2</sup>

<br>
Answering the first question will not be too difficult to do so all we need to do is run a multiple regression test with all categorical data over the success factor (pledged / given) and exam the output of the calculation (see below)

<br><br>
as for the second questions it will most likely be a t-test over the same point of data (see below)