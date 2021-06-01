-- mau
select date_trunc('mon', timestampist) as month,
		count(distinct userid) as mau
from clickstream c 
where timestampist::date between '2020-12-01' and '2021-02-28'
group by 1
order by 1

--HQ mau
select date_trunc('mon', record_date) as month,
		count(distinct usr_id) as hq_mau
from analytics_dna.leadscore_result_archive_master_v8 lramv
where record_date::date between '2020-12-01' and '2021-02-28'
and lead_score > 5
group by 1
order by 1

-- Pro orders in dec
With pro_order as (select o.userid, min(creationtime_istdate) as date
	                from public.orders o
	                where o.amount > 0
	                and o.entityid in ('5f7483dc5ae2aa336b4cbf73','5fc9f1a2475fd21f5d76bdb7','5fca038b170aef0dd551469c','5fca0599ee0217281df18733','5fca21a22aa1c906398fa7c3',
	                                    '5fd8a4740b5fe951a499787d','5f7483db08414e0c0a82be9a','5fca2366475fd21f5d76cf00','5fca96c7170aef0dd5517a25','5fca9972170aef0dd5517ab2',
	                                    '5fca9b0b2aa1c906398fd103', '5fd8a8368a549c2d60336527','5f7483dc1ca6e86be3d27174','5fca9da0ee0217281df1b8d4','5fca9ebc170aef0dd5517b8b',
	                                    '5fca9f402aa1c906398fd14b','5fcaa040170aef0dd5517bac','5fd8aad31c698759d133669f','5f7483dc7e137468c53d1c1e','5fcaa9442aa1c906398fd946',
	                                    '5fcaaa922aa1c906398fda21','5fcaabd82aa1c906398fdb1b','5fcaadab2aa1c906398fdc4e','5fd8ac8b1c698759d13367c6','5f7483dc5ae2aa336b4cbf75',
	                                    '5fcab0c72aa1c906398fdd81','5fcad8da170aef0dd5518c61','5fcadbc4170aef0dd5518ce5','5fcadcc72aa1c906398fe2c3','5fd8aefed294a47a81f204ca',
	                                    '5f6036c70e30474b8f0df7ef','5f7483dc08414e0c0a82be9c','5fd74936bba2ff0f97af93f8','5f7483dcf84d83726f7e5f6f','5f56295995b020491a546142',
	                                    '5fcb193e2aa1c906398ff52f','5fcae5b52a2b9551deceafad','5fcb1a1bee0217281df1dd97','5fcaf13e8b59f46fc4341446','5fcb044b2a2b9551deceb80c',
	                                    '5fcb1bc88b59f46fc43421e8','5fcae93e170aef0dd5518fca','5fcb1de02a2b9551decec062','5fcaf2358b59f46fc4341471','5fcb0530170aef0dd5519820',
	                                    '5fcb1f5a2a2b9551decec0b6','5fcaed3d170aef0dd55190ca','5fcb21248b59f46fc43423c3','5fcaf315170aef0dd5519269','5fcb061e2a2b9551deceb8bc',
	                                    '5fcb22602aa1c906398ff8a2','5fcaee882a2b9551deceb1a8','5fcb237c8b59f46fc43424a9','5fcaf4022a2b9551deceb304','5fcb06ec2a2b9551deceb900',
	                                    '5fd8b2dc62f6a615f0cff04b','5fd8b43e1c698759d1336dd9','5fd8b64362f6a615f0cff364','5fd8b8771c698759d133716c','5fd8ba3c62f6a615f0cff710',
	                                    '5f572254672ba05206da7b72','5f7483dc1ca6e86be3d27171','5fd74de62cf32166ac9c821c','5f7483db7e137468c53d1c1c','5f562b542f1a09485dda0f63',
	                                    '5fcb25f6ee0217281df1e268','5fcaf711ee0217281df1d17b','5fcb27c58b59f46fc434267d','5fcafc628b59f46fc43416d9','5fcb0941170aef0dd5519975',
	                                    '5fcb28d7170aef0dd551a4ef','5fcaf7e62aa1c906398fe945','5fcb2a02ee0217281df1e3f1','5fcafed18b59f46fc4341781','5fcb0a0fee0217281df1d7c6',
	                                    '5fcb2b7c2aa1c906398ffbf9','5fcaf96c8b59f46fc4341632','5fcb2ca18b59f46fc434282c','5fcb0cb4170aef0dd5519aa6','5fcb0ad42aa1c906398fefb3',
	                                    '5fcb2d92170aef0dd551a6ed','5fcafa608b59f46fc4341665','5fcb2e65ee0217281df1e5ec','5fcb00962a2b9551deceb684','5fcb0bb58b59f46fc4341bbd',
	                                    '5fd8bd091c698759d133763a','5fd8bf0d8a549c2d60337964','5fd8c2cf1c698759d1337e72','5fd8c49e62f6a615f0d0046c','5fd8c68f0b5fe951a4999819',
	                                    '5f86ee73dc795853dd0dd940','5f86eeb63472605a906cebcd')
	                and o.paymentstatus in ('PAID','PARTIALLY_PAID','FORFEITED','PAYMENT_SUSPENDED')
	                and (o.agentcode is null or o.agentcode ='VD00028')
	                and o.useremail not like '%vedantu.com'
	                and creationtime_istdate::date between '2020-12-01' and '2020-12-31'
                	group by 1)
 select po.userid, u.channel_source, u.creationtime_istdate as signup_date, po.date as order_date
 from pro_order po
 left join public.user u on u.id = po.userid
 group by 1,2,3,4
 
 -- pro order-engagement distribution 
 with signup as (select id as userid,
						min(creationtime_istdate) as date
				from public.user
				where creationtime_istdate::date between '2020-12-01' and '2020-12-31'
				and studentinfo_grade in (5,6,7,8,9,10,11)
				group by 1),
crash_order as (select distinct o.userid, 
                        min(o.creationtime_istdate) as date
                from public.orders o
                where o.amount > 0
                and o.entityid in ('5f7483dc5ae2aa336b4cbf73','5fc9f1a2475fd21f5d76bdb7','5fca038b170aef0dd551469c','5fca0599ee0217281df18733','5fca21a22aa1c906398fa7c3',
                                    '5fd8a4740b5fe951a499787d','5f7483db08414e0c0a82be9a','5fca2366475fd21f5d76cf00','5fca96c7170aef0dd5517a25','5fca9972170aef0dd5517ab2',
                                    '5fca9b0b2aa1c906398fd103', '5fd8a8368a549c2d60336527','5f7483dc1ca6e86be3d27174','5fca9da0ee0217281df1b8d4','5fca9ebc170aef0dd5517b8b',
                                    '5fca9f402aa1c906398fd14b','5fcaa040170aef0dd5517bac','5fd8aad31c698759d133669f','5f7483dc7e137468c53d1c1e','5fcaa9442aa1c906398fd946',
                                    '5fcaaa922aa1c906398fda21','5fcaabd82aa1c906398fdb1b','5fcaadab2aa1c906398fdc4e','5fd8ac8b1c698759d13367c6','5f7483dc5ae2aa336b4cbf75',
                                    '5fcab0c72aa1c906398fdd81','5fcad8da170aef0dd5518c61','5fcadbc4170aef0dd5518ce5','5fcadcc72aa1c906398fe2c3','5fd8aefed294a47a81f204ca',
                                    '5f6036c70e30474b8f0df7ef','5f7483dc08414e0c0a82be9c','5fd74936bba2ff0f97af93f8','5f7483dcf84d83726f7e5f6f','5f56295995b020491a546142',
                                    '5fcb193e2aa1c906398ff52f','5fcae5b52a2b9551deceafad','5fcb1a1bee0217281df1dd97','5fcaf13e8b59f46fc4341446','5fcb044b2a2b9551deceb80c',
                                    '5fcb1bc88b59f46fc43421e8','5fcae93e170aef0dd5518fca','5fcb1de02a2b9551decec062','5fcaf2358b59f46fc4341471','5fcb0530170aef0dd5519820',
                                    '5fcb1f5a2a2b9551decec0b6','5fcaed3d170aef0dd55190ca','5fcb21248b59f46fc43423c3','5fcaf315170aef0dd5519269','5fcb061e2a2b9551deceb8bc',
                                    '5fcb22602aa1c906398ff8a2','5fcaee882a2b9551deceb1a8','5fcb237c8b59f46fc43424a9','5fcaf4022a2b9551deceb304','5fcb06ec2a2b9551deceb900',
                                    '5fd8b2dc62f6a615f0cff04b','5fd8b43e1c698759d1336dd9','5fd8b64362f6a615f0cff364','5fd8b8771c698759d133716c','5fd8ba3c62f6a615f0cff710',
                                    '5f572254672ba05206da7b72','5f7483dc1ca6e86be3d27171','5fd74de62cf32166ac9c821c','5f7483db7e137468c53d1c1c','5f562b542f1a09485dda0f63',
                                    '5fcb25f6ee0217281df1e268','5fcaf711ee0217281df1d17b','5fcb27c58b59f46fc434267d','5fcafc628b59f46fc43416d9','5fcb0941170aef0dd5519975',
                                    '5fcb28d7170aef0dd551a4ef','5fcaf7e62aa1c906398fe945','5fcb2a02ee0217281df1e3f1','5fcafed18b59f46fc4341781','5fcb0a0fee0217281df1d7c6',
                                    '5fcb2b7c2aa1c906398ffbf9','5fcaf96c8b59f46fc4341632','5fcb2ca18b59f46fc434282c','5fcb0cb4170aef0dd5519aa6','5fcb0ad42aa1c906398fefb3',
                                    '5fcb2d92170aef0dd551a6ed','5fcafa608b59f46fc4341665','5fcb2e65ee0217281df1e5ec','5fcb00962a2b9551deceb684','5fcb0bb58b59f46fc4341bbd',
                                    '5fd8bd091c698759d133763a','5fd8bf0d8a549c2d60337964','5fd8c2cf1c698759d1337e72','5fd8c49e62f6a615f0d0046c','5fd8c68f0b5fe951a4999819',
                                    '5f86ee73dc795853dd0dd940','5f86eeb63472605a906cebcd')
                and o.paymentstatus = 'PAID'
                and (o.agentcode is null or o.agentcode ='VD00028')
                and o.useremail not like '%vedantu.com'
                group by 1),
engagement as (select userid,
						mc_attended,
						ft_attended,
						vsat_attended,
						vquiz_attended,
						pdf_attended,
						video_attended,
						tests_attended,
						min(date) as date
				from analytics_reporting.ep_kpi
				group by 1,2,3,4,5,6,7,8)
select case when co.date = s.date and e.date <= s.date then 'd0'
            when co.date = dateadd('day', 1, s.date) and e.date <= dateadd('day', 1, s.date) then 'd1'
            when co.date = dateadd('day', 2, s.date) and e.date <= dateadd('day', 2, s.date) then 'd2'
            when co.date = dateadd('day', 3, s.date) and e.date <= dateadd('day', 3, s.date) then 'd3'
            when co.date = dateadd('day', 4, s.date) and e.date <= dateadd('day', 4, s.date) then 'd4'
            when co.date = dateadd('day', 5, s.date) and e.date <= dateadd('day', 5, s.date) then 'd5' end as daysinceinstall,
            count(distinct case when co.userid is not null then s.userid end) as orders,
		    count(distinct case when co.userid is not null and e.userid is not null and e.mc_attended = 1 then s.userid end) as mc,
		    count(distinct case when co.userid is not null and e.userid is not null and e.tests_attended = 1 then s.userid end) as tests,
		    count(distinct case when co.userid is not null and e.userid is not null and e.vsat_attended = 1 then s.userid end) as vsat,
		    count(distinct case when co.userid is not null and e.userid is not null and e.vquiz_attended = 1 then s.userid end) as vquiz,
		    count(distinct case when co.userid is not null and e.userid is not null and e.pdf_attended = 1 then s.userid end) as pdf,
		    count(distinct case when co.userid is not null and e.userid is not null and e.ft_attended = 1 then s.userid end) as ft,
		    count(distinct case when co.userid is not null and e.userid is not null and e.video_attended = 1 then s.userid end) as video,
		    count(distinct case when co.userid is not null and e.userid is not null and e.mc_attended = 1 and tests_attended = 1 then s.userid end) as "mc+tests",
		    count(distinct case when co.userid is not null and e.userid is not null and e.mc_attended = 1 and vsat_attended = 1 then s.userid end) as "mc+vsat",
		    count(distinct case when co.userid is not null and e.userid is not null and e.mc_attended = 1 and vquiz_attended = 1 then s.userid end) as "mc+vquiz",
		    count(distinct case when co.userid is not null and e.userid is not null and e.mc_attended = 1 and pdf_attended = 1 then s.userid end) as "mc+pdf",
		    count(distinct case when co.userid is not null and e.userid is not null and e.mc_attended = 1 and ft_attended = 1 then s.userid end) as "mc+ft",
		    count(distinct case when co.userid is not null and e.userid is not null and e.mc_attended = 1 and video_attended = 1 then s.userid end) as "mc+video",
		    count(distinct case when co.userid is not null and e.userid is not null and e.vquiz_attended = 1 and tests_attended = 1 then s.userid end) as "vquiz+tests",
		    count(distinct case when co.userid is not null and e.userid is not null and e.vquiz_attended = 1 and vsat_attended = 1 then s.userid end) as "vquiz+vsat",
		    count(distinct case when co.userid is not null and e.userid is not null and e.vquiz_attended = 1 and ft_attended = 1 then s.userid end) as "vquiz+ft",
		    count(distinct case when co.userid is not null and e.userid is not null and e.ft_attended = 1 and tests_attended = 1 then s.userid end) as "ft+tests",
		    count(distinct case when co.userid is not null and e.userid is not null and e.ft_attended = 1 and vsat_attended = 1 then s.userid end) as "ft+vsat"
from signup s 
left join crash_order co on co.userid = s.userid
left join engagement e on e.userid = co.userid
group by 1