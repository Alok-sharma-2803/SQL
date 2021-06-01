with nov as
(
select phonenumber,lead_score,case when phonenumber>0 then 'Nov' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,cast(attempted as int),cast(demobooked as int), cast(demodone as int),sales,type,date as assigneddate,team_type as "teamtype",lt_flag from analytics_reporting.parth_data_automation_nov
),
dec as
(
select phonenumber,lead_score,case when phonenumber>0 then 'Dec' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,cast(attempted as int),cast(demobooked as int), cast(demodone as int),sales,type,
case when (date between '2020-12-01' AND '2020-12-31') then date
else '2020-12-31'
end as assigneddate,team_type as "teamtype",lt_flag from analytics_reporting.parth_data_automation_dec_v1
),
jan as
(
select phonenumber,lead_score,case when phonenumber>0 then 'Jan' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,cast(attempted as int),cast(demobooked as int), cast(demodone as int),sales,type,date as assigneddate,team_type as "teamtype",lt_flag from analytics_reporting.parth_data_automation_jan_2021
),
feb as
(
select phonenumber,lead_score,case when phonenumber>0 then 'Feb' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,cast(attempted as int),cast(demobooked as int), cast(demodone as int),sales,type,date as assigneddate,team_type as "teamtype",lt_flag from analytics_reporting.parth_data_automation_feb_2021
),
inst_source as
(
 select * from
 (
 select contactnumber, case when (app_install_source in ('Organic','SEO')) then 'Organic' else 'Paid' end as "source",ROW_NUMBER ()over (partition by contactnumber order by app_install_source desc) as rn
 from user_gaid_mapping u
 inner join public.user u1 on u.userid = u1.id
 )where rn=1
),
agent_activity as
(
select * from
(
select phone, ((paeb.createdon + interval '5hours, 30 minutes')::DATE) as agent_act, row_number() over (partition by paeb.relatedprospectid order by paeb.createdon asc) as "rn1"
from leadsquared.prospectactivity_extensionbase paeb
inner join leadsquared.prospect_base pb on pb.prospectid = paeb.relatedprospectid
where activityevent in (359,309,308,310,311,361,298,323,306)
)
where rn1=1
)

select case when (lead_score between 1 AND 5) then '1 to 5'
            when (lead_score between 6 AND 10) then '6 to 10'
            when (lead_score between 11 AND 15) then '11 to 15'
            when (lead_score between 16 AND 20) then '16 to 20'
            when (lead_score between 21 AND 25) then '21 to 25'
            when (lead_score between 26 AND 30) then '26 to 30'
            when (lead_score between 31 AND 35) then '31 to 35'
            when (lead_score between 36 AND 40) then '36 to 40'
            when (lead_score between 41 AND 45) then '41 to 45'
            when (lead_score between 46 AND 50) then '46 to 50'
            when (lead_score between 51 AND 55) then '51 to 55'
            when (lead_score between 56 AND 60) then '56 to 60'
            when (lead_score between 61 AND 65) then '61 to 65'
            when (lead_score between 66 AND 70) then '66 to 70'
            when (lead_score between 71 AND 75) then '71 to 75'
            when (lead_score between 75 AND 80) then '75 to 80'
            when (lead_score between 81 AND 85) then '81 to 85'
            when (lead_score between 85 AND 90) then '85 to 90'
            when (lead_score between 91 AND 95) then '91 to 95'
            when (lead_score between 95 AND 100) then '95 to 100'
            when lead_score = 0 then 'Zero'
            else 'Other'
            end as "Score_Bucket", case when (actmonth = assignedmonth) then 'NewEng' else 'OldEng' end as "New_Old_Eng",
            case when (usermonth = assignedmonth) then 'NewSignup' else 'OldSignup' end as "New_Old_Signup",
            case when (agent_act > 0 AND agent_act<assigneddate::date) then 'OldAgentAct' else 'NewAgentAct' end as "Agent_Act",
            assignedmonth,cohort, case when (studentinfo_grade in ('5','6','7','8','9','10','11','12','13')) then studentinfo_grade else 'Other' end as "Grade", teamtype, source,
            case when (archived_datetime is null AND assigneddate is null) then '28+'
                 when datediff(day,archived_datetime::date,assigneddate::date)<=1 then '0 to 1'
                 --when datediff(day,archived_datetime::date,assigneddate::date)<=3 then '2 to 3'
                 --when datediff(day,archived_datetime::date,assigneddate::date)<=7 then '4 to 7'
                 when datediff(day,archived_datetime::date,assigneddate::date)<=14 then '2 to 14'
                -- when datediff(day,archived_datetime::date,assigneddate::date)<=28 then '15 to 28'
                 else '15+'
            end as "Recency",
           sum(assigned) as "Assigned", sum(attempted) as "Attempted", sum(demobooked) as "demobooked", sum(demodone) as "DemoDone", sum(sales) as "Sales", sum(lead_score)/count(assigned) as "AvgScore"
       from
(select assigned, attempted, demobooked, demodone, sales, cohort, assignedmonth, ls1.lead_score, his.studentinfo_grade, teamtype, ls.record_date as "archived_datetime", agent_act, assigneddate, u1.creationtime_istdate as "UserDate",
case when creationtime_istdate between '2020-08-01' AND '2020-08-31' then 'Aug'
     when creationtime_istdate between '2020-09-01' AND '2020-09-30' then 'Sep'
     when creationtime_istdate between '2020-10-01' AND '2020-10-31' then 'Oct'
     when creationtime_istdate between '2020-11-01' AND '2020-11-30' then 'Nov'
     when creationtime_istdate between '2020-12-01' AND '2020-12-31' then 'Dec'
     when creationtime_istdate between '2021-01-01' AND '2021-01-31' then 'Jan'
     when creationtime_istdate between '2021-02-01' AND '2021-02-28' then 'Feb'
     else 'Old'
     end as "UserMonth",
case when ls.record_date between '2020-08-01' AND '2020-08-31' then 'Aug'
     when ls.record_date between '2020-09-01' AND '2020-09-30' then 'Sep'
     when ls.record_date between '2020-10-01' AND '2020-10-31' then 'Oct'
     when ls.record_date between '2020-11-01' AND '2020-11-30' then 'Nov'
     when ls.record_date between '2020-12-01' AND '2020-12-31' then 'Dec'
     when ls.record_date between '2021-01-01' AND '2021-01-31' then 'Jan'
     when ls.record_date between '2021-02-01' AND '2021-02-28' then 'Feb'
     else 'Old'
     end as "ActMonth",
case when (ls.studentinfo_examtargetslist ilike '%JEE%' OR ls.studentinfo_examtargetslist ilike '%Engineer%') then 'JEE'
     when (ls.studentinfo_examtargetslist ilike '%NEET%' OR ls.studentinfo_examtargetslist ilike '%Medical%') then 'NEET'
     else 'Others'
    end as "Target_Exam",
source, row_number() over (partition by his.phonenumber, assigneddate order by archived_datetime desc) as row1
from
(
select phonenumber,lead_score,case when phonenumber>0 then 'June' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,attempted, demobooked, demodone,sales,type,assigneddate,teamtype,lt_flag from analytics_reporting.june_july_august_history where assignedmonth = 6
union all
select phonenumber,lead_score,case when phonenumber>0 then 'July' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,attempted, demobooked, demodone,sales,type,assigneddate,teamtype,lt_flag from analytics_reporting.june_july_august_history where assignedmonth = 7
union all
select phonenumber,lead_score,case when phonenumber>0 then 'Aug' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,attempted,demobooked, demodone,sales,type,assigneddate,teamtype,lt_flag from analytics_reporting.august_cvr_data where assignedmonth = 8
union all
select phonenumber,lead_score,case when phonenumber>0 then 'Sep' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,attempted,demobooked, demodone,sales,type,assigneddate,teamtype,lt_flag from analytics_reporting.sep_cvr_data
union all
select phonenumber,lead_score,case when phonenumber>0 then 'Oct' else 'Other' end as "AssignedMonth",cohort,leadgrade as studentinfo_grade,assigned,attempted,demobooked, demodone,sales,type,assigneddate,teamtype,lt_flag from analytics_reporting.october_cvr_data
union all
select * from nov
union all
select * from dec
union all
select * from jan
union all
select * from feb
)his
inner join public.user u1 on his.phonenumber = u1.contactnumber
left join analytics_dna.leadscore_result_archive_master_v8 ls on ls.contactnumber = his.phonenumber AND ls.record_date <= assigneddate
left join analytics_dna.leadscore_result_archive_master_v8 ls1 on ls1.contactnumber = his.phonenumber AND ls1.record_date >= assigneddate and date_trunc('mon', ls1.record_date) <= date_trunc('mon', assigneddate)
left join inst_source on his.phonenumber = inst_source.contactnumber
left join agent_activity on his.phonenumber = agent_activity.phone
where upper(TYPE) not IN ('REFERRAL',
                      'UPSELLING',
                      'FS',
                      'RS',
                      'INBOUND',
                      'INTERNATIONAL')
)
where row1 = 1
group by 1,2,3,4,5,6,7,8,9,10