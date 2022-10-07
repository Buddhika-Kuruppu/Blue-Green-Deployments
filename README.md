# Blue-Green-Deployments

Blue-Green Deployment is a software/Application rollout methodology in order to minimize interuptions/risk caused by deployments. In this strategy two seperate and identical environments as Blue and Green. Usually Blue environments runs current stable release of application while green environments runs newer or Beta release of application. Adopting this strategy increases service availability, minimize deployment risk with simplied rolling back techniques.In testing stage live user traffic is directed to the green environment (Newer reliase) and in case of event traffic redirected towards blue environment (Stable release) while minimizing service downtime.In this strategy live traffic is completely switched towards Green environment during testing (testing for bugs) which is the major difference with Canary deploymeny where only portion of live traffic redirected towards Beta release. Although this is convinient in the perspective of SRE/DevOps Engineers; there are both pros and cons associated in generic viewpoint. 

<img src="https://miro.medium.com/max/1200/1*CvzbdfO9sLeNn_YZfJxu2g.png" alt="Blue-Green" style="width:600px;" class="center"/>

In this repository contains configuration details in Azure environment with Azure Traffic manager for Global DNS Load balancing.
