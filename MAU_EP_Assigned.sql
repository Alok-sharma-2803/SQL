With mc as (select webin.webinar_startdate as mc_date,
                webin.userid
           from (select webinarid, 
                        userid, 
                        webinar_startdate, 
                        grade, 
                        webinarstartdatetime
                    from webinaruserregistrationinfo 
                    where 1=1
                    and webinarattended = true
                    and webinarstartdatetime between '2020-10-01' and '2021-01-31'
                    group by 1,2,3,4,5) as webin
            inner join (select id, sessionid from webinarplatform where entitystate = 'ACTIVE' and webinarcode not like '%superkids%' group by 1,2) as wp on webin.webinarid = wp.id
            inner join (select sessionid, userid, timeinsession, jointime_istdatetime, starttime from gttattendeedetails group by 1,2,3,4,5) as gtt on wp.sessionid = gtt.sessionid and webin.userid = gtt.userid
            inner join (select id, sessionduration from otfsession group by 1,2) as otf on gtt.sessionid = otf.id
            group by 1,2),
ft as (select gtt1.starttime::date as ft_date,
				gtt1.userid
		from public.gttattendeedetails AS gtt1
		inner join (select distinct id
				    from public.user
				    where studentinfo_grade in (6,7,8,9,10,11,12,13)) pu on pu.id = gtt1.userid
		LEFT JOIN otfsession otf ON otf.id = gtt1.sessionid
		left join public.enrollment enroll1 on enroll1.id = gtt1.enrollmentid
		left join public.orders ord on ord.deliverableentityid = enroll1.purchaseenrollmentid
		WHERE gtt1.state = 'SCHEDULED'
		AND gtt1.entitystate = 'ACTIVE'
		AND gtt1.starttime::date between '2020-10-01' and '2021-01-31'
		AND gtt1.role = 'STUDENT'
		and gtt1.attendedtis = 'Present'
		and (ord.entitytype='BUNDLE_TRIAL' 
			or enroll1.bundleenrollment_state IN ('FREE_PASS', 'TRIAL'))
		and gtt1.is_valid_for_attendance='true'
		group by 1,2),
vsat as (select date(testdatetime) as date,
				userid
			from (select  t1.studentid as userid, 
				        t1.duration as timeintest,  
				        t2.duration as testduration,
				        t1.testid,
				        t2.starttime_istdatetime as testdatetime
					from testattemptanalytics t1
					inner join testattempt t2 on t1.studentid = t2.studentid and t1.testid = t2.testid
					where t1.category ilike '%vsat%'
						and t2.starttime_istdatetime::date between '2020-10-01' and '2021-01-31'
						and t1.duration>0)
			group by 1,2),
video as (select date(c.timestampist) as date,
					c.userid
			from public.clickstream_growthapp c
			inner join (select id as userid from public.user where studentinfo_grade in ('6','7','8','9','10') group by 1) u on u.userid = c.userid
			where date(c.timestampist) between '2020-10-01' and '2021-01-31'
			and c.eventlabel in ('app_classroom_video_seen')
			group by 1,2),
tests as (select ct.startedat_istdate::date as testdate,
		        ct.studentid as userid
		        from contentinfo_testattempts ct 
		        inner join (select distinct userid
		                    from clickstream_growthapp cg
		                    inner join (select distinct id
		                                from public.user
		                                where studentinfo_grade in (6,7,8,9,10,11,12,13)) pu
		                                on pu.id = cg.userid
		                    where timestampist::date between '2020-10-01' and '2021-01-31') cga
		        on  cga.userid = ct.studentid           
		        where ct.startedat_istdate::date between '2020-10-01' and '2021-01-31'
		        and ct.duration <= 900000
		        group by 1,2),
pro as (select date(orders.creationtime_istdate) as date,
        		userid
		from orders
		join basesubscriptionpaymentplan on orders.subscriptionplanid = basesubscriptionpaymentplan.id
		where paymentstatus in('PAID','PARTIALLY_PAID','FORFEITED','PAYMENT_SUSPENDED')
		and entitytype in('BUNDLE','BUNDLE_PACKAGE','COURSE_PLAN','OTF','PLAN','OTM_BUNDLE','OTM_BUNDLE_ADVANCE_PAYMENT','BUNDLE_TRIAL')
		and date(orders.creationtime_istdate) between '2020-10-01' and '2021-01-31'
		group by 1,2),
assignment as (select date, userid
				from(select date(assigneddate) as date,
							usr_id as userid
					from analytics_reporting.october_cvr_data
					union all
					select date(date) as date,
							userid
					from analytics_reporting.Parth_Data_Automation_Nov_V8
					union all
					select date(date) as date,
							userid
					from analytics_reporting.parth_data_automation_dec_v8
					union all
					select date(date) as date,
							userid
					from analytics_reporting.parth_data_automation_jan_2021)
				group by 1,2)
select date_trunc('mon', cg.timestampist) as month,
		count(distinct cg.userid) as mau,
		count(distinct case when p.userid is not null then cg.userid end) as pro_attended,
		count(distinct case when p.userid is null 
							and f.userid is not null then cg.userid end) as ft_attended,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is not null then cg.userid end) as vsat_attended,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is not null then cg.userid end) as mc_attended,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is null 
							and cg.eventlabel in ('game_home_screen_ih','play_game_ih') then cg.userid end) as vquiz_attended,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is null 
							and cg.eventlabel not in ('game_home_screen_ih','play_game_ih')
							and t.userid is not null then cg.userid end) as tests_attended,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is null 
							and cg.eventlabel not in ('game_home_screen_ih','play_game_ih')
							and t.userid is null
							and vd.userid is not null then cg.userid end) as video_attended,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is null 
							and cg.eventlabel not in ('game_home_screen_ih','play_game_ih')
							and t.userid is null
							and vd.userid is null then cg.userid end) as No_activity,
		count(distinct ass.userid) as mau_assigned,
		count(distinct case when p.userid is not null then ass.userid end) as pro_assigned,
		count(distinct case when p.userid is null 
							and f.userid is not null then ass.userid end) as ft_assigned,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is not null then ass.userid end) as vsat_assigned,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is not null then ass.userid end) as mc_assigned,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is null 
							and cg.eventlabel in ('game_home_screen_ih','play_game_ih') then ass.userid end) as vquiz_assigned,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is null 
							and cg.eventlabel not in ('game_home_screen_ih','play_game_ih')
							and t.userid is not null then ass.userid end) as tests_assigned,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is null 
							and cg.eventlabel not in ('game_home_screen_ih','play_game_ih')
							and t.userid is null
							and vd.userid is not null then ass.userid end) as video_assigned,
		count(distinct case when p.userid is null 
							and f.userid is null 
							and vs.userid is null 
							and m.userid is null 
							and cg.eventlabel not in ('game_home_screen_ih','play_game_ih')
							and t.userid is null
							and vd.userid is null then ass.userid end) as No_activity_assigned
from public.clickstream_growthapp cg
inner join (select id as userid, studentinfo_grade from public.user group by 1,2) usr on usr.userid = cg.userid
left join mc m on m.userid = cg.userid and date(m.mc_date) = date(cg.timestampist)
left join ft f on f.userid = cg.userid and date(f.ft_date) = date(cg.timestampist)
left join vsat vs on vs.userid = cg.userid and date(vs.date) = date(cg.timestampist)
left join video vd on vd.userid = cg.userid and date(vd.date) = date(cg.timestampist)
left join tests as t on t.userid = cg.userid and date(t.testdate) = date(cg.timestampist)
left join pro p on p.userid = cg.userid and p.date = date(cg.timestampist)
left join assignment as ass on ass.userid = cg.userid and date_trunc('mon',ass.date) = date_trunc('mon', cg.timestampist)
where timestampist between '2020-10-01' and '2021-01-31'
and cg.userid is not null
group by 1
order by 1;