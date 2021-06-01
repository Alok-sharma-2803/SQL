With signup as (select id as userid,
						case when channel_source = 'SEM' then 'Paid' else 'Organic' end as install_source,
						studentinfo_grade as grade,
						studentinfo_board as board,
						min(creationtime_istdate) as signup_date
				from public.user
				group by 1,2,3,4),
ls as (select date_trunc('mon', record_date) as month,
                        usr_id as userid,
                        max(lead_score) as lead_score
                from analytics_dna.leadscore_result_archive_master_v8
                group by 1,2),
traffic as (select month, userid, gaid, appname, lead_score
            from (select date_trunc('mon', c.timestampist) as month,
                        date(c.timestampist) as date,
            			c.userid,
            			c.gaid,
            			c.appname,
            			l.lead_score,
            			row_number() over (partition by month, c.userid order by date) rn
                	from public.clickstream c
                	left join ls l on l.userid = c.userid and l.month = date_trunc('mon', c.timestampist)
                	where date(c.timestampist) between '2021-03-01' and '2021-03-29')
    	    where rn = 1),
install as (select * from (select  date_trunc('mon', trunc(timestamp 'epoch'+(timestamp+19800000)/1000*interval '1 second')) as month,
									date(trunc(timestamp 'epoch'+(timestamp+19800000)/1000*interval '1 second')) as date,
					case when "user_data__aaid" = '' or "user_data__aaid" is null then "last_attributed_touch_data__$aaid"
			            when "last_attributed_touch_data__$aaid" = '' or "last_attributed_touch_data__$aaid" is null then "user_data__aaid"
			            else "user_data__aaid" end as gaid,
			       case when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
			       				and ("last_attributed_touch_data__~campaign" ilike '' or "last_attributed_touch_data__~campaign" is null) 
			       				and ("last_attributed_touch_data__~feature" ilike '' or "last_attributed_touch_data__~feature" is null) then 'Organic'
                        when ("last_attributed_touch_data__~campaign" ilike '' or "last_attributed_touch_data__~campaign" is null) 
                        		and ("last_attributed_touch_data__~agency" in ('PocketAces')) then 'Loco'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and (("last_attributed_touch_data__~campaign" not ilike '' or "last_attributed_touch_data__~campaign" is not null) 
                        		and "last_attributed_touch_data__~channel" not in ('youtube', 'app','Web_Homepage_Direct','Web_Homepage_SMS',
                        															'Web_Homepage_Playstore_Button','Web_Homepage','news18','thehindu_business_line',
                        															'thehindu','dailyhunt','inshorts','TikTok') ) then 'SEO'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and ("last_attributed_touch_data__~channel" in ('Web_Homepage_Direct','Web_Homepage_SMS','Web_Homepage_Playstore_Button',
                    															'Web_Homepage')) then 'Web'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and ("last_attributed_touch_data__~channel" in ('youtube')) then 'Youtube'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and ("last_attributed_touch_data__~channel" in ('thehindu')) then 'The Hindu'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and ("last_attributed_touch_data__~channel" in ('thehindu_business_line')) then 'The Hindu Business line'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and ("last_attributed_touch_data__~channel" in ('inshorts')) then 'Inshorts'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and ("last_attributed_touch_data__~channel" in ('news18')) then 'News18'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and ("last_attributed_touch_data__~channel" in ('app')) then 'Referral'
                        when ("last_attributed_touch_data__~advertising_partner_name" ilike '' or "last_attributed_touch_data__~advertising_partner_name" is null ) 
                        		and ("last_attributed_touch_data__~campaign" in ('V_Quiz')) then 'V_Quiz'
                		when  "last_attributed_touch_data__~advertising_partner_name" ilike 'undisclosed'  
                				and "last_attributed_touch_data__~campaign" ilike 'undisclosed' then 'Facebook'
                        else "last_attributed_touch_data__~advertising_partner_name" end as "Source",
                        name,
	               case when "last_attributed_touch_data__~advertising_partner_name" ilike 'Mobvista' then "last_attributed_touch_data__~customer_campaign"
	                    else "last_attributed_touch_data__~campaign" end as "Campaign",
	               "last_attributed_touch_data__~ad_name" as adname,
	               row_number() over (partition by month, gaid order by date) as rn
			from branchdatarealtime.data
			where date(trunc(timestamp 'epoch'+(timestamp+19800000)/1000*interval '1 second')) between '2021-03-01' and '2021-03-29')
			where rn =1),
servicable as (select date(record_date) as date,
                    usr_id as userid, 
                    v.prospectid,
                    case when mx_sam_allocation = 1 then 0
                            when ownerid in ('07a6c7eb-2e23-11ea-a14b-0268638e5f02','0a50b923-c031-11e9-a003-0268638e5f02') then 0
                            when (substring(right(u1.contactnumber,10),1,1) not in ('6','7','8','9')) then 0
                            when prospectstage in ('Duplicate Lead','Care-V-Student','FOS Demo Done','Invalid Lead','FOS Invalid Lead','6. TOS Done','6a. Sales Warm','7. Sales Won','Refund','Price Verification Done','Price Verification Not Done','Sales Form Filled','Sales Form Re-Filled','Onboarding','Enrollment Done','Live User','Installment Due','Trial Registration Done','Assisted Monthly Enrolment', 'Care-V-Student', 'Enrollment Done', 'Enrollment Pending', 'Installment Due', 'Introduction Done', 'KYC Done', 'KYC Pending - RNR/ Callback', 'KYC Pending-Partial/No documents Receive', 'KYC Unverified', 'KYC Unverified - Details Mismatch', 'KYC Unverified - Partial/ No Documents', 'Live User', 'Onboarding', 'Price Verification Done', 'Price Verification Not Done', 'Product Demo Done', 'Refund', 'Renewal', 'Sales Form Filled', 'Verification Done', 'Verification Not Done', '6. TOS Done', '7. Sales Won') then 0
                            when mx_sub_stage in ('No student','>13 Grade','Course Not Available','<6 grade','Not a Student','> 5 Attempts','Teacher Enquiry','5','No student','6','<4 Grade','>5 DNP','DNP 5','FUW > 5 Attempts','Attempt 5') then 0
                            when ((datediff(day,mx_lastactivitydate::date,cast(record_date as date)))<= 30 AND (prospectstage ilike '%Interest%' OR prospectstage ilike '%Demo%')) then 0
                            when ub.department in ('Admin', 'Marketing', 'Analytics') then 1
                            when task_due_date <= record_date + 7 then 0
                            when ((datediff(day,mx_lastactivitydate::date,cast(record_date as date)))<= 15 AND prospectstage ilike '%Follow%') then 0
                            when (datediff(day,mx_lastactivitydate::date,cast(record_date as date)))<= 7 then 0
                            when (datediff(day,mx_last_assigned_date::date,cast(record_date as date)))<= 7 then 0
                            else 1 
                            end as assign
                from analytics_dna.leadscore_result_archive_master_v8 v
                inner join public.user u1 on u1.id = v.usr_id
                left join  leadsquared.user_base ub on  ub.userid = v.ownerid
                where u1.studentinfo_grade in ('5','6','7','8','9','10','11') 
                AND not(u1.studentinfo_grade in ('5','6','7','8','9') AND (u1.studentinfo_board ilike '%Other%' OR u1.studentinfo_board ilike '%state%' OR u1.studentinfo_board is NULL)) 
                AND lead_languages is not NULL
                AND record_date::date between '2021-03-01' and '2021-03-29' 
                AND lead_score >= 6
                group by 1,2,3,4),
assigned as (select distinct prospectid, sales, sum(bp) as bp, sum(dp) as dp
                from analytics_reporting.parth_data_automation_mar_2021
                where assigned = 1 or assigned = '1'
                group by 1,2),
source as (select cg.month,
                cg.appname,
        		cg.userid,
        		su.install_source,
        		i.source as branch_source,
        		su.grade,
        		su.board,
        		su.signup_date,
        		cg.lead_score,
        		case when date_trunc('mon', su.signup_date) = cg.month then 1 else 0 end as new_Signup,
        		case when date_trunc('mon', su.signup_date) < cg.month then 1 else 0 end as old_Signup,
        		case when (old_signup = 1
        						and (i.campaign in ('RevX','UAC-Ace-11Grade','UAC_ACE_DormantUsers','ACE_MCRegistration_Expt' ,'UAC-Ace-10Grade','UAC-Ace-9Grade','UAC-Ace-8Grade','Criteo1','GMP','Snap_Remarketing','ACE - Registration for Installed users','Facebook1','UAC_ACE_6-7Grade','ACE_DormantUsers','UAC_ACE_NotRegisteredInstallers','UAC_ACE_PseudoUninstallers','VOTE_GoogleACE_Registrations_PanIndia')
        	                        	and i.campaign not like '%install%')) then 'old_signup_remarketing'
        				when new_signup = 1 and i.month = cg.month then 'newsignup_newinstall'
        				when new_signup = 1 then 'newsignup_oldinstall'
        	            when old_signup = 1 and i.name = 'REINSTALL' then 'old_signup_reinstall'
                        when old_signup = 1 then 'old_signup_crm/retention' end as mau_type
            from traffic cg
            left join signup as su on su.userid = cg.userid
            left join install i on i.gaid = cg.gaid and i.month = cg.month
            group by 1,2,3,4,5,6,7,8,9,10,11,12)
select case when appname in ('GROWTHAPP', 'DEXAPP') then 'App' else 'Web' end as "App/Web",
        case when branch_source in ('Organic', 'SEO', 'Web', 'Referral') then 'Organic' else 'Paid' end as source,
        grade,
        case when new_signup = 1 then 'New Signup'
            when old_signup = 1 then 'Old Signup'
            else 'Uncategorized' end as "New/Old",
        branch_source,
        mau_type,
        count(distinct s.userid) as mau,
        count(distinct sv.userid) as servicable,
        count(distinct a.userid) as assignable,
        count(distinct pd.prospectid) as assigned,
        count(distinct case when (pd.sales = 1 or pd.sales = '1') then pd.prospectid end) as sales,
        sum(distinct pd.bp) as bp,
        sum(distinct pd.dp) as dp
from source s
left join servicable sv on sv.userid = s.userid
left join (select * from servicable where assign = 1) a on a.userid = sv.userid
left join assigned pd on pd.prospectid = sv.prospectid
group by 1,2,3,4,5,6