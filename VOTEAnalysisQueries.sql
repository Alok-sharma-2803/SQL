select count(distinct clientid) as #Traffic
from clickstream 
where timestampist::date between  '2021-03-18' and '2021-04-18'
and eventlabel in ('vlp_reg_landing','vlp_reg_landing_app')
--group  by 1



select count(distinct case when slotids is not null then userid end)
from analytics_reporting.vote_registeredusersdata
where registrationdate <='2021-04-18'
group by 1

select count(distinct case when slotids is not null then userid end),
count(case when ((mcattended)>0 or (testattended)>0 or (challengestaken)>0 
or (totalpdfclicked)>0 or(totaldownloadsamplepaper)>0 or (totalvideoclicked)>0 or (TotalReplayWatched)>0) then userid end) as DoneActivityUsers,
count(distinct case when firstexamdate is not null then userid end) as #ExamAttendees
from analytics_reporting.vote_registeredusersdata

select sum (mcattended),sum (testattended),sum (ChallengesTaken),sum (totalpdfclicked),sum (totaldownloadsamplepaper),
sum (totalvideoclicked),sum (TotalReplayWatched) from 
analytics_reporting.vote_registeredusersdata

select 
count(distinct case when mcattended>0 then userid end) #MCAttendees,
count(distinct case when testattended>0 then userid end) #TestAttendees,
count(distinct case when ChallengesTaken>0 then userid end) #ChallengesTaken,
count(distinct case when totalpdfclicked>0 then userid end) #PDFClicks,
count(distinct case when totalvideoclicked>0 then userid end) #VideoClicked,
count(distinct case when totaldownloadsamplepaper>0 then userid end) #SamplePPrDownloaders
from analytics_reporting.vote_registeredusersdata



select utmsource,gradegroup,
count(distinct case when slotids like '%f667b9ac-d0a2-41b4-9853-154a4cbc55f0%' then userid end) as FirstSlotSelected,
count(distinct case when slotids like '%b8cf90c0-fa40-4d30-8dc3-5f7d5b1ddb27%' then userid end) as SecondSlotSelected,
count(distinct case when slotids like '%ab4591bc-29a7-4624-9c10-f3ec68151fbf%' then userid end) as ThirdSlotSelected,
count(distinct case when slotids like '%6b9004e7-7420-4265-bf63-bec0ace1b3de%' then userid end) as FourthSlotSelected,

from analytics_reporting.vote_registeredusersdata
group by 1,2




select utmsource,
gradegroup,
count(distinct case when slotids like '%f667b9ac-d0a2-41b4-9853-154a4cbc55f0%' then userid end) as FirstSlotSelected,
count(distinct case when slotids like '%b8cf90c0-fa40-4d30-8dc3-5f7d5b1ddb27%' then userid end) as SecondSlotSelected,
count(distinct case when slotids like '%ab4591bc-29a7-4624-9c10-f3ec68151fbf%' then userid end) as ThirdSlotSelected,
count(distinct case when slotids like '%6b9004e7-7420-4265-bf63-bec0ace1b3de%' then userid end) as FourthSlotSelected,
count(distinct case when firstexamattended = 1 then userid end) as FirstExamAttendees,
count(distinct case when secondexamattended = 1 then userid end) as SecondExamAttendees,
count(distinct case when thirdexamattended = 1 then userid end) as ThirdExamAttendees,
count(distinct case when fourthexamattended = 1 then userid end) as FourthExamAttendees
from analytics_reporting.vote_registeredusersdata
group by 1,2


select 
gradegroup,
count(distinct case when firstexamdate = '2021-03-28' then userid end) as FirstSlotSelected,
count(distinct case when firstexamdate = '2021-04-04' then userid end) as SecondSlotSelected,
count(distinct case when firstexamdate = '2021-04-11' then userid end) as ThirdSlotSelected,
count(distinct case when firstexamdate = '2021-04-18' then userid end) as FourthSlotSelected
from analytics_reporting.vote_registeredusersdata
group by 1





select 
gradegroup,
count(distinct case when firstexamattended = 1 then userid end) as FirstSlotSelected,
count(distinct case when secondexamattended = 1 then userid end) as SecondSlotSelected,
count(distinct case when thirdexamattended = 1 then userid end) as ThirdSlotSelected,
count(distinct case when fourthexamattended = 1 then userid end) as FourthSlotSelected
from analytics_reporting.vote_registeredusersdata
group by 1



select 
--utmsource,gradegroup,
count(distinct case when firstexamattended = 1 and secondexamattended = 0 and thirdexamattended = 0 and fourthexamattended = 0 then userid end) as OnlyFirstExamAttendees,
count(distinct case when firstexamattended = 1 and secondexamattended = 1 and thirdexamattended = 0 and fourthexamattended = 0 then userid end) as FirstSecExamAttendees,
count(distinct case when firstexamattended = 1 and secondexamattended = 0 and thirdexamattended = 1 and fourthexamattended = 0 then userid end) as FirstThirExamAttendees,
count(distinct case when firstexamattended = 1 and secondexamattended = 0 and thirdexamattended = 1 and fourthexamattended = 1 then userid end) as FirstFourExamAttendees,
count(distinct case when firstexamattended = 1 and secondexamattended = 1 and thirdexamattended = 1 and fourthexamattended = 1 then userid end) as FirstSecThirdFourExamAttendees,
count(distinct case when firstexamattended = 0 and secondexamattended = 1 and thirdexamattended = 0 and fourthexamattended = 0 then userid end) as OnlySecExamAttendees,
count(distinct case when firstexamattended = 0 and secondexamattended = 1 and thirdexamattended = 1 and fourthexamattended = 0 then userid end) as SecThirExamAttendees,
count(distinct case when firstexamattended = 0 and secondexamattended = 1 and thirdexamattended = 1 and fourthexamattended = 1 then userid end) as SecThirFourExamAttendees,
count(distinct case when firstexamattended = 0 and secondexamattended = 0 and thirdexamattended = 1 and fourthexamattended = 0 then userid end) as OnlyThirExamAttendees,
count(distinct case when firstexamattended = 0 and secondexamattended = 0 and thirdexamattended = 1 and fourthexamattended = 1 then userid end) as ThirFourExamAttendees,
count(distinct case when firstexamattended = 0 and secondexamattended = 0 and thirdexamattended = 0 and fourthexamattended = 1 then userid end) as OnlyFourExamAttendees,
count(distinct case when firstexamattended = 1 then userid end) as FirstExamAttendees,
count(distinct case when secondexamattended = 1 then userid end) as SecondExamAttendees,
count(distinct case when thirdexamattended = 1 then userid end) as ThirdExamAttendees,
count(distinct case when fourthexamattended = 1 then userid end) as FourthExamAttendees
from analytics_reporting.vote_registeredusersdata
--group by 1,2



select 
gradegroup,utmsource,
case when registrationdate::date = signupdate::date then 'New' else 'Old' end as UserType,
count(distinct userid) as #Registrations,
count(distinct case when firstexamdate is not null then userid end) as #Attendees,
count(case when ((mcattended)>0 or (testattended)>0 or (challengestaken)>0 
or (totalpdfclicked)>0 or(totaldownloadsamplepaper)>0 or (totalvideoclicked)>0 or (TotalReplayWatched)>0) then userid end) as DoneActivityUsers,
count(distinct case when mcattended>0 then userid end) as #MCAttendees,
count(distinct case when testattended>0 then userid end) as #TestAttendees,
count(distinct case when ChallengesTaken>0 then userid end) as #ChallengeTakers,
count(distinct case when totalpdfclicked>0 then userid end) as #PDFClickers,
count(distinct case when totaldownloadsamplepaper>0 then userid end) as #SamplePaperDownloaders,
count(distinct case when totalvideoclicked>0 then userid end) as #VideoClickers,
count(distinct case when TotalReplayWatched>0 then userid end) as #ReplayWatchers
from 
analytics_reporting.vote_registeredusersdata
where registrationdate::date<='2021-04-18'
group by 1,2,3


select 
--serviceable_flag,
--gradegroup,utmsource,
--case when registrationdate::date = signupdate::date then 'New' else 'Old' end as UserType,
--case when firstexamdate is not null then 'ExamAttendee' else 'Old' end as UserType,
count(distinct userid) as #Registrations,
count(distinct case when assignsafterregistration>0 then userid end) as #Assigned,
count(distinct case when attemptsafterregistration>0 then userid end) as #Attempted,
count(distinct case when connectsafterregistration >0 then userid end) as #Connected,
count(distinct case when orders >0 then userid end) as #Sales
--sum(distinct case when bp >0 then bp end) as #Amount
from 
analytics_reporting.vote_registeredusersdata
--where (firstexamattended = 1 or secondexamattended = 1 or thirdexamattended = 1)
group by 1,2,3,4,5


select count(distinct case when orders >0 then userid end) as #Sales
from 
analytics_reporting.vote_registeredusersdata

select 
studentinfo_grade,
count(distinct case when assigned_date>='2021-03-18' then userid end) as AssignedLeads,
count(distinct case when (fos_attempted_calls+is_attempted_calls)>=1 and assigned_date>='2021-03-18' then userid end) as AttemptedLeads,
count(distinct case when (fos_connected_calls+is_connected_calls)>=1 and assigned_date>='2021-03-18' then userid end) as ConnectedLeads,
count(distinct case when (no_of_orders)>0 and assigned_date>='2021-03-18' then userid end) as Sales
from analytics_reporting.sales_assigned_arlv1 
where 
assigned_date>='2021-03-18'
--and userid in 
--(select distinct userid from voteregistration)
group by 1



select
count(distinct case when assigned_date>'2021-03-18' then a.userid end) as Assigns,
count(distinct case when assigned_date>'2021-03-18' and (fos_attempted_calls+is_attempted_calls)>=1 then a.userid end) as Attempts,
count(distinct case when assigned_date<=order_date and no_of_orders>0 then a.userid end) as #Sales
from analytics_reporting.sales_assigned_arlv1 a 
--inner join analytics_reporting.vote_registeredusersdata vr 
--on a.userid = vr.userid 
where assigned_date between '2021-03-18' and '2021-04-18'
and userid in (select distinct userid from voteregistration)

select record_date::Date,mapped_city_or_state,lead_languages,count(*)
from analytics_dna.leadscore_result_archive_master_v8 
where record_date::Date>='2021-03-19'
group by 1,2,3



select count()


