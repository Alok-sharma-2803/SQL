-- DAU split
insert into analytics_reporting.dau_kpi
With signup as (select id as userid,
						case when channel_source = 'SEM' then 'Paid' else 'Organic' end as install_source,
						studentinfo_grade as grade,
						studentinfo_board as board,
						min(creationtime_istdate) as signup_date
				from public.user
				group by 1,2,3,4),
install as (select * from (select  date(trunc(timestamp 'epoch'+(timestamp+19800000)/1000*interval '1 second')) as date,
									to_char(trunc(timestamp 'epoch'+(timestamp+19800000)/1000*interval '1 second'), 'HH24:MI:SS') as time,
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
	               row_number() over (partition by date, gaid order by time) as rn
			from branchdatarealtime.data
			where date(trunc(timestamp 'epoch'+(timestamp+19800000)/1000*interval '1 second')) between '2021-03-01' and '2021-03-07')
			where rn =1)
select date(timestampist) as date,
		cg.userid,
		su.install_source,
		su.grade,
		su.board,
		su.signup_date,
		i.date as branch_event_date,
		i.name as branch_event_name,
		i.source as branch_source,
		i.adname,
		i.campaign,
		case when date(su.signup_date) = date(cg.timestampist) then 1 else 0 end as new_Signup,
		case when date(su.signup_date) < date(cg.timestampist) then 1 else 0 end as old_Signup,
		case when new_signup = 1 and i.date = date(cg.timestampist) then 1 else 0 end as newsignup_newinstall,
		case when new_signup = 1 and (i.date != date(cg.timestampist) or i.date is null) then 1 else 0 end newsignup_oldinstall,
		case when old_signup = 1 and i.name = 'REINSTALL' then 1 else 0 end as old_signup_reinstall,
		case when (old_signup = 1 and i.name != 'REINSTALL'
									and (i.campaign in ('ACE - Registration for Installed users','ACE_MCRegistration_Expt','Criteo-Vedantu IN - Android MC - Grade 11','Criteo-Vedantu IN InApp Android Masterclass CAM_Grade11','Facebook AppEngagement-DormantUsers ','Facebook AppReEngage-Registrations','Facebook AppReEngagementNotRegistered','GMP - YOptima','RevX','UAC_ACE _NotRegisteredInstallers','UAC_ACE_DormantUsers','UAC-Ace-10Grade','UAC-Ace-11Grade','UAC-Ace-8Grade','UAC-Ace-9Grade')
				                        	and i.campaign not like '%install%')) then 1 else 0 end as old_signup_remarketing,
        case when old_signup = 1 and old_signup_remarketing = 0 and old_signup_reinstall = 0 then 1 else 0 end as oldsignup_crmretention
from (select date(timestampist) as timestampist, 
				userid,
				gaid 
		from public.clickstream_growthapp 
		where date(timestampist) between '2021-03-01' and '2021-03-07'
		group by 1,2,3) cg
left join signup as su on su.userid = cg.userid
left join install i on i.gaid = cg.gaid and i.date = date(cg.timestampist)
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17;