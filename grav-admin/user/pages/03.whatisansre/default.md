What is an SRE?  
Time, Knowledge, Responsibility (TKR)

In the beginning, there was the techie.  And the techie thought very very hard about what they and/or their employer were sending out to customers and how they were going to go about delivering that to customers and how they were going to test and how they were going to backup the database and how they were going to build things…  It's a very very long list of things that need to be done.

And as it turns out, there are only so many hours in the day.  So even with 10x developers, you end up splitting responsibilities.  And ideally there's an alignment of knowledge with those responsibilities so that I'm not plunged into a time-sensitive need where I have no context.

Time -> Responsibilities -> Knowledge -> More K-aligned Responsibilities

And one of those earliest splits was that of the SRE vs. the SWE
What is an SRE?

Fundamentally, an SRE is:
People who think about how we're getting code and data to customers in a reliable consistent way as opposed to people who deliver features
Develop the knowledge and scope their responsibility down to use their time to answer those questions.

If I'm changing the color of a button on the website, I'm not against it.  You're also probably misusing my knowledge, interests, and experience.

A good SRE is:
Lazy
Impatient
ADHD
I should not check on things, things should yell at me.
And even then only when I couldn't automate them into functionality to limit the amount of yelling.

The rest of this document details various ways in which those SRE's and other non-feature SWE's tend to be organized as teams get larger.
Organization of your SREs:
When you add SRE's to your companies:
Embedded vs. Platform?
Who holds which pagers?
Embedded vs. Platform
Embedded SRE is exactly that.  You find an SRE, they embed with the dev team, get very very good at whatever the dev team does and build customized solutions to integrate the dev team with the underlying infrastructure so the devs can focus on pure features.

Platform SRE are instead cross-functional service teams that define the Platform on which our services run.

Because there is only so much Time in the day and every company has a lot of problems, you say "The company shall log to this specific vendor using these specific libraries" and then make that an entire team's problem.  Repeat for Alerting, Monitoring, email groups, S3 retention policies, the Database backup, Password Management, cross-region dataflows, build/test/deploy for >80% of the company (Mobile is hard).

As opposed to making every single Embedded SRE solve these problems individually

Alternate names might be the Tools team or somewhat jokingly the Everything Team.

In sufficiently large companies, the answer is both.  The Platform team or teams build tools which the Embedded SRE's integrate their customer-facing services into.

If you're small enough, I prefer platform teams because they let you force multiply across the entire company.  "We the SRE team bring you the LOG() function in every language of choice and run the logging vendor integration and auth and the devs actually write the LOG() calls"

Do they hold the pager or not?
This is a multi-part question.

Do you have enough SRE's to fill a rotation?
Coming back into TKR problems, does your possibly company-wide SRE team have enough understanding of the source code for the entire company to fix the bugs
Or are devs graded on perf based on their ability not to cause 300% SRE turnover with 400 pages/week?

My personal preference for minimum viable rotation is 4, my personal preference is that pager duty (lit. PagerDuty) be aligned with knowledge or I have a lever to push to make the pages stop.

Google thought minimum viable rotation was 7 on 2 continents 1 week at a time with 5 minute response and 5 x2 continents on 30 minute SLA.  The comp time was amazing, I will miss it, I made my choice to leave Google, and that should probably be considered a ceiling.

What gets covered under your platform team?
The SRE team targets almost everything.  A partial by no means complete list I reserve the right to expand in future.
Build/Deploy
Cloud integration and general maintenance
Observation
Calling out ELK/Logging in particular
Devex
QA
Security
The hardware/configuration side of DBA
Everything else
Build/Deploy
How do we as a team safely integrate, validate, and deploy new code?

Who's running the Jenkins or the Github Actions?  How do we get from submitted code to Production deploys how fast with what checks?  If we have 50 microservices, did someone please define Service so that we can template the concept of Deploy as part of our Platform?  When builds fail, how do we integrate with Observation to tell someone?  Where do build logs go?  If we have a build farm, how big is it and how do we send jobs to worker nodes?

If we're deploying, do we have Canaries?  What metrics are we alerting on for said Canaries?

Meanwhile as part of defining Service, I probably expanded my scope to include IAC and running the K8s cluster.
Observation
How do we as a team know what's going on and how and when do we know when it fails and who do we tell?

Logging
Alerting
Monitoring
Tracing

Not necessarily specific messages, but things like "We have several hundred nodes in an orchestration cluster.  Where do logs end up and what grep alerts do I have firing pages and filling dashboards and where do those alerts go and where are those dashboards?"

And of course, downstream of that, once I have defined a Service, maybe I can keep consulting with those same devs and set up a default set of metrics and alerts as part of our Platform.
Cloud Integration
Putting buffers between the Cloud and our devs

The RDS CreateDBInstance command contains dozens of flags, is async so it doesn't actually validate that your Create worked, and doesn't let you tag your instance as part of the launch

At this company, I give you a function with 4 commands, tag things properly for you, and integrate with our Auth functions correctly and pre-configure backups in line with company policy.  With an extra flag, I'll even pre-load a backup for you (Warning: May or may not take hours).

Repeat for everything in the company that works with AWS.
Devex
Developer Experience - How do devs work?  How can I make them work faster?

How do devs integrate with our systems from their work laptops and can we make this process as fast and easy as possible.  What is making our devs slow and how can I make devs fast.
QA
See my notes on QA

I will happily build you a framework with which you can write your tests for your code.  If I'm writing all the tests for the devs, we have a problem
Security
Related to all of this, how do you grant SSH into hosts, but not let some hacker out of China drop a BTC miner on your hardware?

IAM and also Observability overlap with a lot of input into your design choices.
Everything else
My best day was "Why do we spend $200K/month on S3 backups?"  And the answer was "We had a backup system with no retention policy and had been backing up 10-15TB of databases every 6 hours for 5 years."

Whose job is that?  It better be _someone's_ and I'd really like it to be mine.
Addendum: Things that are part of SRE, but you probably shouldn't hire SRE's to do them:
IT Team (Overlap 4/10)
IT does in-office tech support
I'm not saying your SRE's shouldn't be responsible for shipping laptops or even that your SRE's shouldn't be responsible for imaging laptops.  And in fact "A dev's SSH isn't playing nice with the bastion host" is absolutely my problem.

And within that constraint, in what will be a running theme of this, your IT team has different tools, skillsets, and focuses than your SREs.  They're also notably cheaper in my experience since when the SRE is fixing the office wifi, they're not knocking $2 Million/year off your S3 bill and SRE's get paid somewhat accordingly.
DBA (Overlap 2/10)
A DBA thinks really really hard about how to make your database queries run faster.

They have spent years or even decades staring at configuration flags and query explanations making your queries run faster.

This is the less employable half of the split where you used to have someone who ran the hardware and thought about the queries as part of being the DBA and was effectively an on-prem SRE specifically for the database.

The reason it's less employable is that everyone outsourced their dedicated DBA to the 5 of these that currently work on *all* of RDS.  Until you need to use those big guns, these responsibilities are often taken over by devs while thinking about hardware and redundancy/reliability/backup and restore and authentication is largely taken care of by SRE's.

So there used to be tens of thousands of these as I have described them and as we all move into hosted cloud, pretty soon there'll be about 200.  In the world.

Personally: I've worked in situations where I can be a really really _bad_ one of these on Day 1 (Indexes, shards, certain small copied tables on every node if multi-node) and upskill quickly, but I end up thinking harder about backups and reliability and things.  Also, see the discussion about "less employable" and the cloud.

My honest recommendation is to just get a support contract.

Recommended Coworkers:
https://www.linkedin.com/in/sushim-mitra-6627b714/ - Looks like he's pivoted, but he might pivot back.
The support contract that is 1/100th of his salary in exchange for 1/100th of his time and some latency.
QA (Overlap 6/10)
QA thinks very very hard about how we run tests at this company and also which tests we run and the toolsets around running those tests.

The reason this splits off really early is that:

There are a set of people who apply back and forth for a set of jobs that attract those people.  Titles are your recruiting.
It ends up being a consistent, ongoing day's work really fast.
Because someone stole it really early, I generally end up outsourcing those responsibilities and implicitly that knowledge.

To put this in perspective, Compass had 2 SRE's  on the everything team and 2 QA engineers.

Alternatives:

Toolsets are the responsibility of the Build SREs, tests themselves are the responsibility of the underlying devs, Build gets together with Monitoring and points build failure alerts upstream to the dev teams running the tests.

Personally: I can do it, I enjoy it, I'd prefer it not be my entire job, and if it becomes my entire job, either I've found meaning in it or we go get a dedicated one.
Security (Overlap 8/10, completely different career upskilling path)
Devops/SRE is a superset of Blue Team Security

However, your security people tend to have different skillsets acquired via different paths.  Much like QA said "How do we test this?" and turned it into a 40+-hour a week paid position, Security thinks "How do we control access and flow and see if anyone's being naughty in these systems?" and probably turned it into a set of positions.

Just like QA, they are explicitly asking a subset of the questions your SRE team is asking using a different set of tools and a different set of career paths than your SRE's as a really involved full-time position.   High levels of overlap with Monitoring/Alerting/Observability SRE.

There's also Red Team Security which is its own thing almost entirely, mostly double-checking that your .

Personally: I'm sort of OK in that I have a ton of configuration and observability experience and then the exciting question of "Help me figure out what a BTC miner on my machine looks like so that I can observe that as an alert and do DFIR after the fact of the breach" is something where I'd ask for assistance.

Given that Dragos is a billion-dollar-plus unicorn, it seems like I'm not alone.
