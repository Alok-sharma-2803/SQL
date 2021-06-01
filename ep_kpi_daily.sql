insert into analytics_reporting.ep_kpi
With signup as (select id as userid,
						studentinfo_grade as grade,
						studentinfo_board as board,
						case when channel_source = 'SEM' then 'Paid' else 'Organic' end as source_of_install,
						contactnumber,
						email,
						firstname,
						gender,
						locationinfo_city as city,
						min(creationtime_istdate) as signup_date
				from public.user
				group by 1,2,3,4,5,6,7,8,9),
vquiz as (select date, userid, eventlabel, count(distinct sessionid) as frequency, sum(max-min) as timeinsession
			from (select date(timestampist) as date,
					sessionid,
					userid,
					eventlabel,
					min(timestamp)/60000::float as min, 
					max(timestamp)/60000::float as max
			from public.clickstream
			where date(timestampist) between '2021-03-11' and '2021-03-14'
			and eventlabel in ('play_game_ih','app_study_pdf_item_clicked')
			group by 1,2,3,4)
			group by 1,2,3),
mc as (select date(webin.webinar_startdate) as mc_date,
            	webin.userid,
                count(distinct gtt.sessionid) as frequency,   
                sum(gtt.timeinsession/60000::float) as timeinsession,
                sum(otf.sessionduration/60000::float) as sessionduration
        	from webinaruserregistrationinfo webin
    		inner join webinarplatform wp on webin.webinarid = wp.id
    		inner join gttattendeedetails gtt on wp.sessionid = gtt.sessionid and webin.userid = gtt.userid
            inner join otfsession otf on gtt.sessionid = otf.id
    		where wp.entitystate = 'ACTIVE' 
    		and date(webin.webinar_startdate) between '2021-03-11' and '2021-03-14'
    		and gtt.role = 'STUDENT'
    		and wp.webinarstatus = 'ACTIVE'
    		and webinarattended = true
    		and webin.userid is not null
    		group by 1,2),
ft as (select gtt1.starttime::date as ft_date,
				gtt1.userid,
				count(gtt1.sessionid) as frequency,
				sum(otf.sessionduration/60000::float) as sessionduration,
				sum(gtt1.timeinsession/60000::float) as timeinsession 
		from public.gttattendeedetails AS gtt1
		LEFT JOIN otfsession otf ON otf.id = gtt1.sessionid
		left join public.enrollment enroll1 on enroll1.id = gtt1.enrollmentid
		left join public.orders ord on ord.deliverableentityid = enroll1.purchaseenrollmentid
		WHERE gtt1.state = 'SCHEDULED'
		AND gtt1.entitystate = 'ACTIVE'
		AND date(gtt1.starttime) between '2021-03-11' and '2021-03-14'
		AND gtt1.role = 'STUDENT'
		and gtt1.attendedtis = 'Present'
		and (ord.entitytype='BUNDLE_TRIAL' 
			or enroll1.bundleenrollment_state IN ('FREE_PASS', 'TRIAL'))
		and gtt1.is_valid_for_attendance='true'
		and gtt1.userid is not null
		group by 1,2),
vsat as (select date(testdatetime) as date,
				userid,
				count(distinct testid) as frequency,
				sum(1.00*timeintest/60000::float) as timeintest,
				sum(1.00*testduration/60000::float) as testduration
			from (select  t1.studentid as userid, 
				        t1.duration as timeintest,  
				        t2.duration as testduration,
				        t1.testid,
				        t2.starttime_istdatetime as testdatetime
					from testattemptanalytics t1
					inner join testattempt t2 on t1.studentid = t2.studentid and t1.testid = t2.testid
					where t1.category ilike '%vsat%'
					and t1.studentid is not null
						and date(t2.starttime_istdatetime) between '2021-03-11' and '2021-03-14'
						and t1.duration>0)
			group by 1,2),
video as (select date(c.timestampist) as date,
					c.userid,
			        count(distinct c.sessionid) as frequency
			from public.clickstream_growthapp c
			where date(c.timestampist) between '2021-03-11' and '2021-03-14'
			and c.eventlabel in ('app_classroom_video_seen')
			and c.userid is not null
			group by 1,2),
tests as (select ct.startedat_istdate::date as testdate,
		        ct.studentid as userid,
		        count(ct.testid) as frequency,
		        sum(ct.duration/60000::float) as sessionduration,
		        sum(ct.timetakenbystudent/60000::float) as timeintest
		        from contentinfo_testattempts ct 
		        inner join (select distinct userid
		                    from clickstream_growthapp cg
		                    where date(timestampist) between '2021-03-07' and '2021-03-10') cga
		        on  cga.userid = ct.studentid           
		        where date(ct.startedat_istdate) between '2021-03-11' and '2021-03-14'
		        and ct.studentid is not null
		        and ct.duration <= 900000
		        group by 1,2)
select source.date,
		source.userid,
		s.grade,
		s.board,
		s.source_of_install,
		s.contactnumber,
		s.email,
		s.gender,
		s.city,
		case when m.userid is not null then 1 else 0 end as mc_attended,
		case when m.userid is not null then m.frequency else null end as mc_frequency,
		case when m.userid is not null then m.timeinsession else null end as mc_timeinsession,
		case when m.userid is not null then m.sessionduration else null end as mc_sessionduration,
		case when f.userid is not null then 1 else 0 end as ft_attended,
		case when f.userid is not null then f.frequency else null end as ft_frequency,
		case when f.userid is not null then f.timeinsession else null end as ft_timeinsession,
		case when f.userid is not null then f.sessionduration else null end as ft_sessionduration,
		case when vs.userid is not null then 1 else 0 end as vsat_attended,
		case when vs.userid is not null then vs.frequency else null end as vsat_frequency,
		case when vs.userid is not null then vs.timeintest else null end as vsat_timeinsession,
		case when vs.userid is not null then vs.testduration else null end as vsat_sessionduration,
		case when vd.userid is not null then 1 else 0 end as video_attended,
		case when vd.userid is not null then vs.frequency else null end as video_frequency,
		case when t.userid is not null then 1 else 0 end as tests_attended,
		case when t.userid is not null then t.frequency else null end as tests_frequency,
		case when t.userid is not null then t.timeintest else null end as tests_timeinsession,
		case when t.userid is not null then t.sessionduration else null end as tests_sessionduration,
		case when vq.eventlabel = 'play_game_ih' and vq.userid is not null then 1 else 0 end as vquiz_attended,
		case when vq.eventlabel = 'play_game_ih' and vq.userid is not null then vq.frequency end as vquiz_frequency,
		case when vq.eventlabel = 'play_game_ih' and vq.userid is not null then vq.timeinsession end as vquiz_timeinsession,
		case when vq.eventlabel = 'app_study_pdf_item_clicked' and vq.userid is not null then 1 else 0 end as pdf_attended,
		s.signup_date
from (select date, userid
		from (select date(mc_date) as date, userid from mc group by 1,2
				union all
			  select date(ft_date) as date, userid from ft group by 1,2
			  	union all
		  	  select date, userid from vsat group by 1,2
		  	  	union all
			  select date, userid from video group by 1,2
			  	union all
			  select date(testdate) as date, userid from tests group by 1,2
			  	union all
		  	  select date, userid from vquiz group by 1,2)
  	  	group by 1,2) source
left join signup s on s.userid = source.userid
left join mc m on m.userid = source.userid and date(m.mc_date) = source.date
left join ft f on f.userid = source.userid and date(f.ft_date) = source.date
left join vsat vs on vs.userid = source.userid and date(vs.date) = source.date
left join video vd on vd.userid = source.userid and date(vd.date) = source.date
left join tests as t on t.userid = source.userid and date(t.testdate) = source.date
left join vquiz as vq on vq.userid = source.userid and vq.date = source.date
where source.date between '2021-03-11' and '2021-03-14'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
order by 1;