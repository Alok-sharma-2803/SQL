create table analytics_reporting.reengagement_temp as (
with users as (select * 
				from (select u.id,
								u.studentinfo_grade as grade,
								u.locationinfo_city as city,
								ugm.gaid,
								u.creationtime_istdate as signup_date,
								row_number() over (partition by id order by signup_date desc) rn
						from public.user u
						left join public.user_gaid_mapping ugm on ugm.userid = u.id
						group by 1,2,3,4,5)
				where rn = 1),
ep as (select *
		from(select distinct userid,
						case when sum(mc_attended) > 0 then 1 else 0 end as mc_attended,
						case when sum(vsat_attended) > 0 then 1 else 0 end as vsat_attended,
						case when sum(tests_attended) > 0 then 1 else 0 end as tests_attended,
						case when sum(video_attended) > 0 then 1 else 0 end as video_attended,
						case when sum(ft_attended) > 0 then 1 else 0 end as ft_attended,
						case when sum(vquiz_attended) > 0 then 1 else 0 end as vquiz_attended,
						case when sum(pdf_attended) > 0 then 1 else 0 end as pdf_attended,
						max(date) as last_ep_date,
						row_number() over (partition by userid) as rn
				from analytics_reporting.ep_kpi ek
				where date between '2021-02-01' and '2021-03-10'
				group by 1)
		where rn = 1),
ls as (select distinct usr_id as userid, 
				max(lead_score) as lead_score,
				max(record_date) as last_applaunch_date
		from analytics_dna.leadscore_result_archive_master_v8 lramv
		where record_date::date between '2021-02-01' and '2021-03-10'
		group by 1),
active_sales as (select distinct u.id as userid
					from leadsquared.prospectactivity_extensionbase paeb
					inner join leadsquared.prospect_base pb on pb.prospectid = paeb.relatedprospectid
					left join public.user u on u.contactnumber = pb.phone
					where (paeb.createdon + interval '5hours, 30 minutes') >= current_date -8
					and activityevent in (359,309,308,310,311,361,298,323,306)
					group by 1)
select u.gaid,
		u.city,
		u.grade,
		l.last_applaunch_date as last_astivity_date,
		e.last_ep_date,
		l.lead_score,
		case when a.userid is not null then 1 else 0 end as active_sales,
		case when e.mc_attended = 1 then 1 else 0 end as mc_attended,
		case when e.vsat_attended = 1 then  1 else 0 end as vsat_attended,
		case when e.tests_attended = 1 then  1 else 0 end as tests_attended,
		case when e.video_attended = 1 then  1 else 0 end as video_attended,
		case when e.ft_attended = 1 then  1 else 0 end as ft_attended,
		case when e.vquiz_attended = 1 then  1 else 0 end as vquiz_attended,
		case when e.pdf_attended = 1 then  1 else 0 end as pdf_attended
from ls l
left join ep e on e.userid = l.userid
left join users u on u.id = l.userid
left join active_sales a on a.userid = l.userid
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14)