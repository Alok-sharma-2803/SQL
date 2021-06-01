create table analytics_reporting.vote_reportcard_jee_11_12_28mar2021 as (
with cat_max as (select testid,
                        max(correct) as total_correct_topper,
                        max(incorrect) as total_incorrect_topper,
                        max(unattempted) as total_unattempted_topper,
                        max(test_time) as time_taken_mins_topper,
                        max(speed) as speed_topper,
                        max(accuracy) as accuracy_topper,
                        max(physics_correct) as physics_correct_topper,
                        max(physics_incorrect) as physics_incorrect_topper,
                        max(physics_unattempted) as physics_unattempted_topper,
                        max(physics_test_time) as physics_time_taken_mins_topper,
                        max(physics_speed) as physics_speed_topper,
                        max(physics_accuracy) as physics_accuracy_topper,
                        max(chemistry_correct) as checmistry_correct_topper,
                        max(chemistry_incorrect) as chemistry_incorrect_topper,
                        max(chemistry_unattempted) as chemistry_unattempted_topper,
                        max(chemistry_test_time) as chemistry_time_taken_mins__topper,
                        max(chemistry_speed) as chemistry_speed_topper,
                        max(chemistry_accuracy) as chemistry_accuracy_topper,
                        max(math_correct) as math_correct_topper,
                        max(math_incorrect) as math_incorrect_topper,
                        max(math_unattempted) math_unattempted_topper,
                        max(math_test_time) as math_time_taken_mins_topper,
                        max(math_speed) as math_speed_topper,
                        max(math_accuracy) as math_accuracy_topper
                    from (select a.testid,
            					a.studentid,
            					count(distinct case when a.answergiven is not null and a.answergiven = t.answer then a.id end) as correct,
            					count(distinct case when a.answergiven is not null and a.answergiven != t.answer then a.id end) as incorrect,
            					count(distinct case when a.answergiven is null then a.id end) as unattempted,
            					sum(a.duration)/60000::float as test_time,
            					round(correct+incorrect/test_time, 1) as speed,
            					round(correct*100.0/(correct+incorrect),2) as accuracy,
            					
            					count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as physics_correct,
                                count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as physics_incorrect,
                                count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                                        and a.answergiven is null then a.id end) as physics_unattempted,
                                sum(case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/60000::float as physics_test_time,
            					round(physics_correct+physics_incorrect/physics_test_time, 1) as physics_speed,
            					round(physics_correct*100.0/(physics_correct+physics_incorrect),2) as physics_accuracy,
                                
                                count(distinct case when t.subject ilike ('%chem%')
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as chemistry_correct,
                                count(distinct case when t.subject ilike ('%chem%')
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as chemistry_incorrect,
                                count(distinct case when t.subject ilike ('%chem%')
                                        and a.answergiven is null then a.id end) as chemistry_unattempted,
                                sum(case when t.subject ilike ('%chem%') then a.duration end)/60000::float as chemistry_test_time,
            					round(chemistry_correct+chemistry_incorrect/chemistry_test_time, 1) as chemistry_speed,
            					round(chemistry_correct*100.0/(chemistry_correct+chemistry_incorrect),2) as chemistry_accuracy,
                                
                                count(distinct case when t.subject ilike ('%math%')
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as math_correct,
                                count(distinct case when t.subject ilike ('%math%')
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as math_incorrect,
                                count(distinct case when t.subject ilike ('%math%')
                                        and a.answergiven is null then a.id end) as math_unattempted,
                                sum(case when t.subject ilike ('%math%') then a.duration end)/60000::float as math_test_time,
            					round(math_correct+math_incorrect/math_test_time, 1) as math_speed,
            					round(math_correct*100.0/(math_correct+math_incorrect),2) as math_accuracy,
                                
                                count(distinct case when t.difficulty = 'EASY'
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as easy_correct,
                                count(distinct case when t.difficulty = 'EASY'
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as easy_incorrect,
                                count(distinct case when t.difficulty = 'EASY'
                                        and a.answergiven is null then a.id end) as easy_unattempted,
                                sum(case when t.difficulty = 'EASY' then a.duration end)/60000::float as easy_test_time,
            					round(easy_correct+easy_incorrect/test_time, 1) as easy_speed,
            					round(easy_correct*100.0/(easy_correct+easy_incorrect),2) as easy_accuracy,
                                
                                count(distinct case when t.difficulty = 'MODERATE'
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as medium_correct,
                                count(distinct case when t.difficulty = 'MODERATE'
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as medium_incorrect,
                                count(distinct case when t.difficulty = 'MODERATE'
                                        and a.answergiven is null then a.id end) as medium_unattempted,
                                sum(case when t.difficulty = 'MODERATE' then a.duration end)/60000::float as medium_test_time,
            					round(medium_correct+medium_incorrect/medium_test_time, 1) as medium_speed,
            					round(medium_correct*100.0/(medium_correct+medium_incorrect),2) as medium_accuracy,
                                        
                                count(distinct case when t.difficulty = 'TOUGH'
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as hard_correct,
                                count(distinct case when t.difficulty = 'TOUGH'
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as hard_incorrect,
                                count(distinct case when t.difficulty = 'TOUGH'
                                        and a.answergiven is null then a.id end) as hard_unattempted,
                                sum(case when t.difficulty = 'TOUGH' then a.duration end)/60000::float as hard_test_time,
            					round(hard_correct+hard_incorrect/hard_test_time, 1) as hard_speed,
            					round(hard_correct*100.0/(hard_correct+hard_incorrect),2) as hard_accuracy,
                                        
                                count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as knowledge_correct,
                                count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as knowledge_incorrect,
                                count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                                        and a.answergiven is null then a.id end) as knowledge_unattempted,
                                sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') then a.duration end)/60000::float as knowledge_test_time,
            					round(knowledge_correct+knowledge_incorrect/knowledge_test_time, 1) as knowledge_speed,
            					round(knowledge_correct*100.0/(knowledge_correct+knowledge_incorrect),2) as knowledge_accuracy,
                                        
                                count(distinct case when t.skill = 'Reasoning'
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as reasoning_correct,
                                count(distinct case when t.skill = 'Reasoning'
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as reasoning_incorrect,
                                count(distinct case when t.skill = 'Reasoning'
                                        and a.answergiven is null then a.id end) as reasoning_unattempted,
                                sum(case when t.skill = 'Reasoning' then a.duration end)/60000::float as reasoning_test_time,
            					round(reasoning_correct+reasoning_incorrect/reasoning_test_time, 1) as reasoning_speed,
            					round(reasoning_correct*100.0/(reasoning_correct+reasoning_incorrect),2) as reasoning_accuracy,
                                        
                                count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                                        and a.answergiven is not null and a.answergiven = t.answer then a.id end) as application_correct,
                                count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                                        and a.answergiven is not null and a.answergiven != t.answer then a.id end) as application_incorrect,
                                count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                                        and a.answergiven is null then a.id end) as application_unattempted,
                                sum(case when t.skill in ('Application', 'Applications', 'Application ') then a.duration end)/60000::float as application_test_time,
            					round(application_correct+application_incorrect/application_test_time, 1) as application_speed,
            					round(application_correct*100.0/(application_correct+application_incorrect),2) as application_accuracy
            			from Islcmdsquestion t
                        left join vsatquestionattempt as a on t.id = a.questionid
                        left join Islcmdstest ct on ct.id = a.testid
                        left join public.user u on u.id = a.studentid
                        where ct.id in ('605f30f7ec26197f10e752cd', '605f3e512aa0d93684f243ca')
            			group by 1,2)
            			group by 1),
cat_avg as (select ct.id,
                    round(count(distinct case when a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as total_avg_correct,
                    round(count(distinct case when a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as total_avg_incorrect,
                    round(count(distinct case when a.answergiven is null then a.id end)/
                        nullif(count(distinct case when a.answergiven is null then a.studentid end), 0)) as total_avg_unattempted,
                    sum(a.duration)/nullif(count(distinct a.studentid), 0)/60000::float as avg_time_taken_mins,
                    round(total_avg_correct+total_avg_incorrect/avg_time_taken_mins, 1) as avg_speed,
					round(total_avg_correct*100.0/(total_avg_correct+total_avg_incorrect),2) as avg_accuracy,
                    
                    round(count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as physics_avg_correct,
                    round(count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as physics_avg_incorrect,
                    round(count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                            and a.answergiven is null then a.id end)/
                        nullif(count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                            and a.answergiven is null then a.studentid  end), 0)) as physics_avg_unattempted,
                    sum(case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/
                        nullif(count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.studentid end), 0)/60000::float as physics_avg_time_taken_mins,
                    round(physics_avg_correct+physics_avg_incorrect/physics_avg_time_taken_mins, 1) as physics_avg_speed,
					round(physics_avg_correct*100.0/(physics_avg_correct+physics_avg_incorrect),2) as physics_avg_accuracy,
                    
                    round(count(distinct case when t.subject ilike ('%chem%')
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when t.subject ilike ('%chem%')
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as chemistry_avg_correct,
                    round(count(distinct case when t.subject ilike ('%chem%')
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when t.subject ilike ('%chem%')
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as chemistry_avg_incorrect,
                    round(count(distinct case when t.subject ilike ('%chem%')
                            and a.answergiven is null then a.id end)/
                        nullif(count(distinct case when t.subject ilike ('%chem%')
                            and a.answergiven is null then a.studentid end), 0)) as chemistry_avg_unattempted,
                    sum(case when t.subject ilike ('%chem%') then a.duration end)/
                        nullif(count(distinct case when t.subject ilike ('%chem%') then a.studentid end), 0)/60000::float as chemistry_avg_time_taken_mins,
                    round(chemistry_avg_correct+chemistry_avg_incorrect/chemistry_avg_time_taken_mins, 1) as chemistry_avg_speed,
					round(chemistry_avg_correct*100.0/(chemistry_avg_correct+chemistry_avg_incorrect),2) as chemistry_avg_accuracy,
                        
                    round(count(distinct case when t.subject ilike ('%math%')
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when t.subject ilike ('%math%')
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as math_avg_correct,
                    round(count(distinct case when t.subject ilike ('%math%')
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when t.subject ilike ('%math%')
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as math_avg_incorrect,
                    round(count(distinct case when t.subject ilike ('%math%')
                            and a.answergiven is null then t.id end)/
                        nullif(count(distinct case when t.subject ilike ('%math%')
                            and a.answergiven is null then a.studentid end), 0)) as math_avg_unattempted,
                    sum(case when t.subject ilike ('%math%') then a.duration end)/
                        nullif(count(distinct case when t.subject ilike ('%math%') then a.studentid end), 0)/60000::float as math_avg_time_taken_mins,
                    round(math_avg_correct+math_avg_incorrect/math_avg_time_taken_mins, 1) as math_avg_speed,
					round(math_avg_correct*100.0/(math_avg_correct+math_avg_incorrect),2) as math_avg_accuracy,
                        
                    round(count(distinct case when t.difficulty = 'EASY'
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'EASY'
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as easy_avg_correct,
                    round(count(distinct case when t.difficulty = 'EASY'
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'EASY'
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as easy_avg_incorrect,
                    round(count(distinct case when t.difficulty = 'EASY'
                            and a.answergiven is null then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'EASY'
                            and a.answergiven is null then a.studentid end), 0)) as easy_avg_unattempted,
                    sum(case when t.difficulty = 'EASY' then a.duration end)/
                        nullif(count(distinct case when t.difficulty = 'EASY' then a.studentid end), 0)/60000::float as easy_avg_time_taken_mins,
                    round(easy_avg_correct+easy_avg_incorrect/easy_avg_time_taken_mins, 1) as easy_avg_speed,
					round(easy_avg_correct*100.0/(easy_avg_correct+easy_avg_incorrect),2) as easy_avg_accuracy,
                        
                    round(count(distinct case when t.difficulty = 'MODERATE'
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'MODERATE'
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as medium_avg_correct,
                    round(count(distinct case when t.difficulty = 'MODERATE'
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'MODERATE'
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as medium_avg_incorrect,
                    round(count(distinct case when t.difficulty = 'MODERATE'
                            and a.answergiven is null then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'MODERATE'
                            and a.answergiven is null then a.studentid end), 0)) as medium_avg_unattempted,
                    sum(case when t.difficulty = 'MODERATE' then a.duration end)/
                        nullif(count(distinct case when t.difficulty = 'MODERATE' then a.studentid end), 0)/60000::float as medium_avg_time_taken_mins,
                    round(medium_avg_correct+medium_avg_incorrect/medium_avg_time_taken_mins, 1) as medium_avg_speed,
					round(medium_avg_correct*100.0/(medium_avg_correct+medium_avg_incorrect),2) as medium_avg_accuracy,
                        
                    round(count(distinct case when t.difficulty = 'TOUGH'
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'TOUGH'
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as hard_avg_correct,
                    round(count(distinct case when t.difficulty = 'TOUGH'
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'TOUGH'
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as hard_avg_incorrect,
                    round(count(distinct case when t.difficulty = 'TOUGH'
                            and a.answergiven is null then a.id end)/
                        nullif(count(distinct case when t.difficulty = 'TOUGH'
                            and a.answergiven is null then a.studentid end), 0)) as hard_avg_unattempted,
                    sum(case when t.difficulty = 'TOUGH' then a.duration end)/
                        nullif(count(distinct case when t.difficulty = 'TOUGH' then a.studentid end), 0)/60000::float as hard_avg_time_taken_mins,
                    round(hard_avg_correct+hard_avg_incorrect/hard_avg_time_taken_mins, 1) as hard_avg_speed,
					round(hard_avg_correct*100.0/(hard_avg_correct+hard_avg_incorrect),2) as hard_avg_accuracy,
                        
                    round(count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as knowledge_avg_correct,
                    round(count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as knowledge_avg_incorrect,
                    round(count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                            and a.answergiven is null then a.id end)/
                        nullif(count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                            and a.answergiven is null then a.studentid end), 0)) as knowledge_avg_unattempted,
                    sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') then a.duration end)/
                        nullif(count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') then a.studentid end), 0)/60000::float as knowledge_avg_time_taken_mins,
                    round(knowledge_avg_correct+knowledge_avg_incorrect/knowledge_avg_time_taken_mins, 1) as knowledge_avg_speed,
					round(knowledge_avg_correct*100.0/(knowledge_avg_correct+knowledge_avg_incorrect),2) as knowledge_avg_accuracy,
                        
                    round(count(distinct case when t.skill = 'Reasoning'
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when t.skill = 'Reasoning'
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as reasoning_avg_correct,
                    round(count(distinct case when t.skill = 'Reasoning'
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when t.skill = 'Reasoning'
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as reasoning_avg_incorrect,
                    round(count(distinct case when t.skill = 'Reasoning'
                            and a.answergiven is null then a.id end)/
                        nullif(count(distinct case when t.skill = 'Reasoning'
                            and a.answergiven is null then a.studentid end), 0)) as reasoning_avg_unattempted,
                    sum(case when t.skill = 'Reasoning' then a.duration end)/
                        nullif(count(distinct case when t.skill = 'Reasoning' then a.studentid end), 0)/60000::float as reasoning_avg_time_taken_mins,
                    round(reasoning_avg_correct+reasoning_avg_incorrect/reasoning_avg_time_taken_mins, 1) as reasoning_avg_speed,
					round(reasoning_avg_correct*100.0/(reasoning_avg_correct+reasoning_avg_incorrect),2) as reasoning_avg_accuracy,
                        
                    round(count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                            and a.answergiven is not null and a.answergiven = t.answer then a.id end)/
                        nullif(count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                            and a.answergiven is not null and a.answergiven = t.answer then a.studentid end), 0)) as application_avg_correct,
                    round(count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                            and a.answergiven is not null and a.answergiven != t.answer then a.id end)/
                        nullif(count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                            and a.answergiven is not null and a.answergiven != t.answer then a.studentid end), 0)) as application_avg_incorrect,
                    round(count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                            and a.answergiven is null then a.id end)/
                        nullif(count(distinct case when t.skill = 'Reasoning'
                            and a.answergiven is null then a.studentid end), 0)) as application_avg_unattempted,
                    sum(case when t.skill = 'Reasoning' then a.duration end)/
                        nullif(count(distinct case when t.skill = 'Reasoning' then a.studentid end), 0)/60000::float as application_avg_time_taken_mins,
                    round(application_avg_correct+application_avg_incorrect/application_avg_time_taken_mins, 1) as application_avg_speed,
					round(application_avg_correct*100.0/(application_avg_correct+application_avg_incorrect),2) as application_avg_accuracy
            from Islcmdsquestion t
            left join vsatquestionattempt as a on t.id = a.questionid
            left join Islcmdstest ct on ct.id = a.testid
            left join public.user u on u.id = a.studentid
            where ct.id in ('605f30f7ec26197f10e752cd', '605f3e512aa0d93684f243ca')
            group by 1)
select a.testid,
        a.studentid as userid,
        u.firstname,
        u.studentinfo_grade,
        u.studentinfo_board,
        u.studentinfo_stream as stream,
        u.locationinfo_state as state,
        ct.category,
        a.creationtime_istdate::date as attempt_date,
        ct.quscount as total_questions,
        
        totalmarks as max_marks,
        
        ca.total_avg_correct,
        ca.total_avg_incorrect,
        ca.total_avg_unattempted,
        ca.avg_time_taken_mins,
        ca.avg_speed,
        ca.avg_accuracy,
        ca.physics_avg_correct,
        ca.physics_avg_incorrect,
        ca.physics_avg_unattempted,
        ca.physics_avg_time_taken_mins,
        ca.physics_avg_speed,
        ca.physics_avg_accuracy,
        ca.chemistry_avg_correct,
        ca.chemistry_avg_incorrect,
        ca.chemistry_avg_unattempted,
        ca.chemistry_avg_time_taken_mins,
        ca.chemistry_avg_speed,
        ca.chemistry_avg_accuracy,
        ca.math_avg_correct,
        ca.math_avg_incorrect,
        ca.math_avg_unattempted,
        ca.math_avg_time_taken_mins,
        ca.math_avg_speed,
        ca.math_avg_accuracy,
        
        cm.total_correct_topper,
        cm.total_incorrect_topper,
        cm.total_unattempted_topper,
        cm.time_taken_mins_topper,
        cm.speed_topper,
        cm.accuracy_topper,
        cm.physics_correct_topper,
        cm.physics_incorrect_topper,
        cm.physics_unattempted_topper,
        cm.physics_time_taken_mins_topper,
        cm.physics_speed_topper,
        cm.physics_accuracy_topper,
        cm.checmistry_correct_topper,
        cm.chemistry_incorrect_topper,
        cm.chemistry_unattempted_topper,
        cm.chemistry_time_taken_mins__topper,
        cm.chemistry_speed_topper,
        cm.chemistry_accuracy_topper,
        cm.math_correct_topper,
        cm.math_incorrect_topper,
        cm.math_unattempted_topper,
        cm.math_time_taken_mins_topper,
        cm.math_speed_topper,
        cm.math_accuracy_topper,
        
        sum(case when a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - sum(case when a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as total_marks,
        
        round(percent_rank() over (order by total_marks)*100.0, 2) as air,
        
        count(distinct case when a.answergiven is not null and a.answergiven = t.answer then t.id end) as total_correct,
        count(distinct case when a.answergiven is not null and a.answergiven != t.answer then t.id end) as total_incorrect,
        count(distinct case when a.answergiven is null then t.id end) as total_unattempted,
        sum(a.duration)/60000::float as time_taken_mins,
		round(total_correct+total_incorrect/time_taken_mins, 1) as total_speed,
		round(total_correct*100.0/(total_correct+total_incorrect),2) as total_accuracy,
        
        
        count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as physics_correct,
        count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as physics_incorrect,
        count(distinct case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is null then t.id end) as physics_unattempted,
        sum(case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/60000::float as physics_time_taken_mins,
        sum(case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%'))
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as physics_total_marks,
		round(physics_correct+physics_incorrect/physics_time_taken_mins, 1) as physics_speed,
		round(physics_correct*100.0/(physics_correct+physics_incorrect),2) as physics_accuracy,

        count(distinct case when t.subject ilike ('%chem%')
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as chemistry_correct,
        count(distinct case when t.subject ilike ('%chem%')
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as chemistry_incorrect,
        count(distinct case when t.subject ilike ('%chem%')
                                and a.answergiven is null then t.id end) as chemistry_unattempted,
        sum(case when t.subject ilike ('%chem%') then a.duration end)/60000::float as chemistry_time_taken_mins,
        sum(case when t.subject ilike ('%chem%')
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when t.subject ilike ('%chem%')
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as chemistry_total_marks,
		round(chemistry_correct+chemistry_incorrect/chemistry_time_taken_mins, 1) as chemistry_speed,
		round(chemistry_correct*100.0/(chemistry_correct+chemistry_incorrect),2) as chemistry_accuracy,

        count(distinct case when t.subject ilike ('%math%')
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as math_correct,
        count(distinct case when t.subject ilike ('%math%')
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as math_incorrect,
        count(distinct case when t.subject ilike ('%math%')
                                and a.answergiven is null then t.id end) as math_unattempted,
        sum(case when t.subject ilike ('%math%') then a.duration end)/60000::float as math_time_taken_mins,
        sum(case when t.subject ilike ('%math%')
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when t.subject ilike ('%math%')
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as math_total_marks,
		round(math_correct+math_incorrect/math_time_taken_mins, 1) as math_speed,
		round(math_correct*100.0/(math_correct+math_incorrect),2) as math_accuracy,

        
        count(distinct case when t.difficulty = 'EASY'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as easy_correct,
        count(distinct case when t.difficulty = 'EASY'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as easy_incorrect,
        count(distinct case when t.difficulty = 'EASY'
                                and a.answergiven is null then t.id end) as easy_unattempted,
        sum(case when t.difficulty = 'EASY' then a.duration end)/60000::float as easy_time_taken_mins,
        sum(case when t.difficulty = 'EASY'
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when t.difficulty = 'EASY'
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as easy_total_marks,
		round(easy_correct+easy_incorrect/easy_time_taken_mins, 1) as easy_speed,
		round(easy_correct*100.0/(easy_correct+easy_incorrect),2) as easy_accuracy,
        
        count(distinct case when t.difficulty = 'MODERATE'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as medium_correct,
        count(distinct case when t.difficulty = 'MODERATE'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as medium_incorrect,
        count(distinct case when t.difficulty = 'MODERATE'
                                and a.answergiven is null then t.id end) as medium_unattempted,
        sum(case when t.difficulty = 'MODERATE' then a.duration end)/60000::float as medium_time_taken_mins,
        sum(case when t.difficulty = 'MODERATE'
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when t.difficulty = 'MODERATE'
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as medium_total_marks,
		round(medium_correct+medium_incorrect/medium_time_taken_mins, 1) as medium_speed,
		round(medium_correct*100.0/(medium_correct+medium_incorrect),2) as medium_accuracy,
        
        count(distinct case when t.difficulty = 'TOUGH'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as hard_correct,
        count(distinct case when t.difficulty = 'TOUGH'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as hard_incorrect,
        count(distinct case when t.difficulty = 'TOUGH'
                                and a.answergiven is null then t.id end) as hard_unattempted,
        sum(case when t.difficulty = 'TOUGH' then a.duration end)/60000::float as hard_time_taken_mins,
        sum(case when t.difficulty = 'TOUGH'
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when t.difficulty = 'TOUGH'
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as hard_total_marks,
		round(hard_correct+hard_incorrect/hard_time_taken_mins, 1) as hard_speed,
		round(hard_correct*100.0/(hard_correct+hard_incorrect),2) as hard_accuracy,
        
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as Knowledge_correct,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as Knowledge_incorrect,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                                and a.answergiven is null then t.id end) as Knowledge_unattempted,
        sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') then a.duration end)/60000::float as Knowledge_time_taken_mins,
        sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge')
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as Knowledge_total_marks,
		round(knowledge_correct+knowledge_incorrect/knowledge_time_taken_mins, 1) as knowledge_speed,
		round(knowledge_correct*100.0/(knowledge_correct+knowledge_incorrect),2) as knowledge_accuracy,
        
        count(distinct case when t.skill = 'Reasoning'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as reasoning_correct,
        count(distinct case when t.skill = 'Reasoning'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as reasoning_incorrect,
        count(distinct case when t.skill = 'Reasoning'
                                and a.answergiven is null then t.id end) as reasoning_unattempted,
        sum(case when t.skill = 'Reasoning' then a.duration end)/60000::float as reasoning_time_taken_mins,
        sum(case when t.skill = 'Reasoning'
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when t.skill = 'Reasoning'
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as reasoning_total_marks,
		round(reasoning_correct+reasoning_incorrect/reasoning_time_taken_mins, 1) as reasoning_speed,
		round(reasoning_correct*100.0/(reasoning_correct+reasoning_incorrect),2) as reasoning_accuracy,
        
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as application_correct,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as application_incorrect,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ')
                                and a.answergiven is null then t.id end) as application_unattempted,
        sum(case when t.skill in ('Application', 'Applications', 'Application ') then a.duration end)/60000::float as application_time_taken_mins,
        sum(case when t.skill in ('Application', 'Applications', 'Application ')
                        and a.answergiven is not null and a.answergiven = t.answer then marks_positive end) - 
                sum(case when t.skill in ('Application', 'Applications', 'Application ')
                        and a.answergiven is not null and a.answergiven != t.answer then marks_negative end) as application_total_marks,
		round(application_correct+application_incorrect/application_time_taken_mins, 1) as application_speed,
		round(application_correct*100.0/(application_correct+application_incorrect),2) as application_accuracy,

        count(distinct case when t.difficulty = 'EASY' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as physics_easy_correct,
        count(distinct case when t.difficulty = 'EASY' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as physics_easy_incorrect,
        count(distinct case when t.difficulty = 'EASY' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is null then t.id end) as physics_easy_unattempted,
        sum(case when t.difficulty = 'EASY' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/60000::float as physics_easy_time_taken_mins,
		round(physics_easy_correct+physics_easy_incorrect/physics_easy_time_taken_mins, 1) as physics_easy_speed,
		round(physics_easy_correct*100.0/(physics_easy_correct+physics_easy_incorrect),2) as physics_easy_accuracy,

        count(distinct case when t.difficulty = 'EASY' and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as chemistry_easy_correct,
        count(distinct case when t.difficulty = 'EASY' and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as chemistry_easy_incorrect,
        count(distinct case when t.difficulty = 'EASY' and t.subject ilike ('%chem%') 
                                and a.answergiven is null then t.id end) as chemistry_easy_unattempted,
        sum(case when t.difficulty = 'EASY' and t.subject ilike ('%chem%') then a.duration end)/60000::float as chemistry_easy_time_taken_mins,
		round(chemistry_easy_correct+chemistry_easy_incorrect/chemistry_easy_time_taken_mins, 1) as chemistry_easy_speed,
		round(chemistry_easy_correct*100.0/(chemistry_easy_correct+chemistry_easy_incorrect),2) as chemistry_easy_accuracy,

        count(distinct case when t.difficulty = 'EASY' and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as math_easy_correct,
        count(distinct case when t.difficulty = 'EASY' and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as math_easy_incorrect,
        count(distinct case when t.difficulty = 'EASY' and t.subject ilike ('%math%') 
                                and a.answergiven is null then t.id end) as math_easy_unattempted,
        sum(case when t.difficulty = 'EASY' and t.subject ilike ('%math%') then a.duration end)/60000::float as math_easy_time_taken_mins,
		round(math_easy_correct+math_easy_incorrect/math_easy_time_taken_mins, 1) as math_easy_speed,
		round(math_easy_correct*100.0/(math_easy_correct+math_easy_incorrect),2) as math_easy_accuracy,

        count(distinct case when t.difficulty = 'MODERATE' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as physics_medium_correct,
        count(distinct case when t.difficulty = 'MODERATE' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as physics_medium_incorrect,
        count(distinct case when t.difficulty = 'MODERATE' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is null then t.id end) as physics_medium_unattempted,
        sum(case when t.difficulty = 'MODERATE' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/60000::float as physics_medium_time_taken_mins,
		round(physics_medium_correct+physics_medium_incorrect/physics_medium_time_taken_mins, 1) as physics_medium_speed,
		round(physics_medium_correct*100.0/(physics_medium_correct+physics_medium_incorrect),2) as physics_medium_accuracy,

        count(distinct case when t.difficulty = 'MODERATE' and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as chemistry_medium_correct,
        count(distinct case when t.difficulty = 'MODERATE' and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as chemistry_medium_incorrect,
        count(distinct case when t.difficulty = 'MODERATE' and t.subject ilike ('%chem%') 
                                and a.answergiven is null then t.id end) as chemistry_medium_unattempted,
        sum(case when t.difficulty = 'MODERATE' and t.subject ilike ('%chem%') then a.duration end)/60000::float as chemistry_medium_time_taken_mins,
		round(chemistry_medium_correct+chemistry_medium_incorrect/chemistry_medium_time_taken_mins, 1) as chemistry_medium_speed,
		round(chemistry_medium_correct*100.0/(chemistry_medium_correct+chemistry_medium_incorrect),2) as chemistry_medium_accuracy,

        count(distinct case when t.difficulty = 'MODERATE' and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as math_medium_correct,
        count(distinct case when t.difficulty = 'MODERATE' and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as math_medium_incorrect,
        count(distinct case when t.difficulty = 'MODERATE' and t.subject ilike ('%math%') 
                                and a.answergiven is null then t.id end) as math_medium_unattempted,
        sum(case when t.difficulty = 'MODERATE' and t.subject ilike ('%math%') then a.duration end)/60000::float as math_medium_time_taken_mins,
		round(math_medium_correct+math_medium_incorrect/math_medium_time_taken_mins, 1) as math_medium_speed,
		round(math_medium_correct*100.0/(math_medium_correct+math_medium_incorrect),2) as math_medium_accuracy,

        count(distinct case when t.difficulty = 'TOUGH' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as physics_hard_correct,
        count(distinct case when t.difficulty = 'TOUGH' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as physics_hard_incorrect,
        count(distinct case when t.difficulty = 'TOUGH' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is null then t.id end) as physics_hard_unattempted,
        sum(case when t.difficulty = 'TOUGH' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/60000::float as physics_hard_time_taken_mins,
		round(physics_hard_correct+physics_hard_incorrect/physics_hard_time_taken_mins, 1) as physics_hard_speed,
		round(physics_hard_correct*100.0/(physics_hard_correct+physics_hard_incorrect),2) as physics_hard_accuracy,

        count(distinct case when t.difficulty = 'TOUGH' and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as chemistry_hard_correct,
        count(distinct case when t.difficulty = 'TOUGH' and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as chemistry_hard_incorrect,
        count(distinct case when t.difficulty = 'TOUGH' and t.subject ilike ('%chem%') 
                                and a.answergiven is null then t.id end) as chemistry_hard_unattempted,
        sum(case when t.difficulty = 'TOUGH' and t.subject ilike ('%chem%') then a.duration end)/60000::float as chemistry_hard_time_taken_mins,
		round(chemistry_hard_correct+chemistry_hard_incorrect/chemistry_hard_time_taken_mins, 1) as chemistry_hard_speed,
		round(chemistry_hard_correct*100.0/(chemistry_hard_correct+chemistry_hard_incorrect),2) as chemistry_hard_accuracy,

        count(distinct case when t.difficulty = 'TOUGH' and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as math_hard_correct,
        count(distinct case when t.difficulty = 'TOUGH' and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as math_hard_incorrect,
        count(distinct case when t.difficulty = 'TOUGH' and t.subject ilike ('%math%') 
                                and a.answergiven is null then t.id end) as math_hard_unattempted,
        sum(case when t.difficulty = 'TOUGH' and t.subject ilike ('%math%') then a.duration end)/60000::float as math_hard_time_taken_mins,
		round(math_hard_correct+math_hard_incorrect/math_hard_time_taken_mins, 1) as math_hard_speed,
		round(math_hard_correct*100.0/(math_hard_correct+math_hard_incorrect),2) as math_hard_accuracy,

        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as physics_knowledge_correct,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as physics_knowledge_incorrect,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is null then t.id end) as physics_knowledge_unattempted,
        sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/60000::float as physics_knowledge_time_taken_mins,
		round(physics_knowledge_correct+physics_knowledge_incorrect/physics_knowledge_time_taken_mins, 1) as physics_knowledge_speed,
		round(physics_knowledge_correct*100.0/(physics_knowledge_correct+physics_knowledge_incorrect),2) as physics_knowledge_accuracy,

        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as chemistry_knowledge_correct,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as chemistry_knowledge_incorrect,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.subject ilike ('%chem%') 
                                and a.answergiven is null then t.id end) as chemistry_knowledge_unattempted,
        sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.subject ilike ('%chem%') then a.duration end)/60000::float as chemistry_knowledge_time_taken_mins,
		round(chemistry_knowledge_correct+chemistry_knowledge_incorrect/chemistry_knowledge_time_taken_mins, 1) as chemistry_knowledge_speed,
		round(chemistry_knowledge_correct*100.0/(chemistry_knowledge_correct+chemistry_knowledge_incorrect),2) as chemistry_knowledge_accuracy,

        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as math_knowledge_correct,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as math_knowledge_incorrect,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.subject ilike ('%math%') 
                                and a.answergiven is null then t.id end) as math_knowledge_unattempted,
        sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.subject ilike ('%math%') then a.duration end)/60000::float as math_knowledge_time_taken_mins,
		round(math_knowledge_correct+math_knowledge_incorrect/math_knowledge_time_taken_mins, 1) as math_knowledge_speed,
		round(math_knowledge_correct*100.0/(math_knowledge_correct+math_knowledge_incorrect),2) as math_knowledge_accuracy,

        count(distinct case when t.skill = 'Reasoning' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as physics_reasoning_correct,
        count(distinct case when t.skill = 'Reasoning' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as physics_reasoning_incorrect,
        count(distinct case when t.skill = 'Reasoning' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is null then t.id end) as physics_reasoning_unattempted,
        sum(case when t.skill = 'Reasoning' and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/60000::float as physics_reasoning_time_taken_mins,
		round(physics_reasoning_correct+physics_reasoning_incorrect/physics_reasoning_time_taken_mins, 1) as physics_reasoning_speed,
		round(physics_reasoning_correct*100.0/(physics_reasoning_correct+physics_reasoning_incorrect),2) as physics_reasoning_accuracy,

        count(distinct case when t.skill = 'Reasoning' and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as chemistry_reasoning_correct,
        count(distinct case when t.skill = 'Reasoning' and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as chemistry_reasoning_incorrect,
        count(distinct case when t.skill = 'Reasoning' and t.subject ilike ('%chem%') 
                                and a.answergiven is null then t.id end) as chemistry_reasoning_unattempted,
        sum(case when t.skill = 'Reasoning' and t.subject ilike ('%chem%') then a.duration end)/60000::float as chemistry_reasoning_time_taken_mins,
		round(chemistry_reasoning_correct+chemistry_reasoning_incorrect/chemistry_reasoning_time_taken_mins, 1) as chemistry_reasoning_speed,
		round(chemistry_reasoning_correct*100.0/(chemistry_reasoning_correct+chemistry_reasoning_incorrect),2) as chemistry_reasoning_accuracy,

        count(distinct case when t.skill = 'Reasoning' and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as math_reasoning_correct,
        count(distinct case when t.skill = 'Reasoning' and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as math_reasoning_incorrect,
        count(distinct case when t.skill = 'Reasoning' and t.subject ilike ('%math%') 
                                and a.answergiven is null then t.id end) as math_reasoning_unattempted,
        sum(case when t.skill = 'Reasoning' and t.subject ilike ('%math%') then a.duration end)/60000::float as math_reasoning_time_taken_mins,
		round(math_reasoning_correct+math_reasoning_incorrect/math_reasoning_time_taken_mins, 1) as math_reasoning_speed,
		round(math_reasoning_correct*100.0/(math_reasoning_correct+math_reasoning_incorrect),2) as math_reasoning_accuracy,

        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as physics_application_correct,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as physics_application_incorrect,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) 
                                and a.answergiven is null then t.id end) as physics_application_unattempted,
        sum(case when t.skill in ('Application', 'Applications', 'Application ') and (t.subject ilike ('%phy%') and t.subject not ilike ('%geo%') and t.subject not ilike ('%math%')) then a.duration end)/60000::float as physics_application_time_taken_mins,
		round(physics_application_correct+physics_application_incorrect/physics_application_time_taken_mins, 1) as physics_application_speed,
		round(physics_application_correct*100.0/(physics_application_correct+physics_application_incorrect),2) as physics_application_accuracy,

        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as chemistry_application_correct,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.subject ilike ('%chem%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as chemistry_application_incorrect,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.subject ilike ('%chem%') 
                                and a.answergiven is null then t.id end) as chemistry_application_unattempted,
        sum(case when t.skill in ('Application', 'Applications', 'Application ') and t.subject ilike ('%chem%') then a.duration end)/60000::float as chemistry_application_time_taken_mins,
		round(chemistry_application_correct+chemistry_application_incorrect/chemistry_application_time_taken_mins, 1) as chemistry_application_speed,
		round(chemistry_application_correct*100.0/(chemistry_application_correct+chemistry_application_incorrect),2) as chemistry_application_accuracy,

        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as math_application_correct,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.subject ilike ('%math%') 
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as math_application_incorrect,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.subject ilike ('%math%') 
                                and a.answergiven is null then t.id end) as math_application_unattempted,
        sum(case when t.skill in ('Application', 'Applications', 'Application ') and t.subject ilike ('%math%') then a.duration end)/60000::float as math_application_time_taken_mins,
        round(math_application_correct+math_application_incorrect/math_application_time_taken_mins, 1) as math_application_speed,
		round(math_application_correct*100.0/(math_application_correct+math_application_incorrect),2) as math_application_accuracy,

        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'EASY'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as knowledge_easy_correct,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'EASY'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as knowledge_easy_incorrect,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'EASY'
                                and a.answergiven is null then t.id end) as knowledge_easy_unattempted,
        sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'EASY' then a.duration end)/60000::float as knowledge_easy_time_taken_mins,
        round(knowledge_easy_correct+knowledge_easy_incorrect/knowledge_easy_time_taken_mins, 1) as knowledge_easy_speed,
		round(knowledge_easy_correct*100.0/(knowledge_easy_correct+knowledge_easy_incorrect),2) as knowledge_easy_accuracy,

        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'MODERATE'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as knowledge_medium_correct,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'MODERATE'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as knowledge_medium_incorrect,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'MODERATE'
                                and a.answergiven is null then t.id end) as knowledge_medium_unattempted,
        sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'MODERATE' then a.duration end)/60000::float as knowledge_medium_time_taken_mins,
        round(knowledge_medium_correct+knowledge_medium_incorrect/knowledge_medium_time_taken_mins, 1) as knowledge_medium_speed,
		round(knowledge_medium_correct*100.0/(knowledge_medium_correct+knowledge_medium_incorrect),2) as knowledge_medium_accuracy,

        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'TOUGH'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as knowledge_hard_correct,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'TOUGH'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as knowledge_hard_incorrect,
        count(distinct case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'TOUGH'
                                and a.answergiven is null then t.id end) as knowledge_hard_unattempted,
        sum(case when t.skill in ('Knowing', 'Knowledge', 'knowledge') and t.difficulty = 'TOUGH' then a.duration end)/60000::float as knowledge_hard_time_taken_mins,
        round(knowledge_hard_correct+knowledge_hard_incorrect/knowledge_hard_time_taken_mins, 1) as knowledge_hard_speed,
		round(knowledge_hard_correct*100.0/(knowledge_hard_correct+knowledge_hard_incorrect),2) as knowledge_hard_accuracy,


        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'EASY'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as reasoning_easy_correct,
        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'EASY'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as reasoning_easy_incorrect,
        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'EASY'
                                and a.answergiven is null then t.id end) as reasoning_easy_unattempted,
        sum(case when t.skill = 'Reasoning' and t.difficulty = 'EASY' then a.duration end)/60000::float as reasoning_easy_time_taken_mins,
        round(reasoning_easy_correct+reasoning_easy_incorrect/reasoning_easy_time_taken_mins, 1) as reasoning_easy_speed,
		round(reasoning_easy_correct*100.0/(reasoning_easy_correct+reasoning_easy_incorrect),2) as reasoning_easy_accuracy,

        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'MODERATE'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as reasoning_medium_correct,
        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'MODERATE'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as reasoning_medium_incorrect,
        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'MODERATE'
                                and a.answergiven is null then t.id end) as reasoning_medium_unattempted,
        sum(case when t.skill = 'Reasoning' and t.difficulty = 'MODERATE' then a.duration end)/60000::float as reasoning_medium_time_taken_mins,
        round(reasoning_medium_correct+reasoning_medium_incorrect/reasoning_medium_time_taken_mins, 1) as reasoning_medium_speed,
		round(reasoning_medium_correct*100.0/(reasoning_medium_correct+reasoning_medium_incorrect),2) as reasoning_medium_accuracy,


        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'TOUGH'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as reasoning_hard_correct,
        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'TOUGH'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as reasoning_hard_incorrect,
        count(distinct case when t.skill = 'Reasoning' and t.difficulty = 'TOUGH'
                                and a.answergiven is null then t.id end) as reasoning_hard_unattempted,
        sum(case when t.skill = 'Reasoning' and t.difficulty = 'TOUGH' then a.duration end)/60000::float as reasoning_hard_time_taken_mins,
        round(reasoning_hard_correct+reasoning_hard_incorrect/reasoning_hard_time_taken_mins, 1) as reasoning_hard_speed,
		round(reasoning_hard_correct*100.0/(reasoning_hard_correct+reasoning_hard_incorrect),2) as reasoning_hard_accuracy,

        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'EASY'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as application_easy_correct,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'EASY'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as application_easy_incorrect,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'EASY'
                                and a.answergiven is null then t.id end) as application_easy_unattempted,
        sum(case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'EASY' then a.duration end)/60000::float as application_easy_time_taken_mins,
        round(application_easy_correct+application_easy_incorrect/application_easy_time_taken_mins, 1) as application_easy_speed,
		round(application_easy_correct*100.0/(application_easy_correct+application_easy_incorrect),2) as application_easy_accuracy,

        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'MODERATE'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as application_medium_correct,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'MODERATE'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as application_medium_incorrect,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'MODERATE'
                                and a.answergiven is null then t.id end) as application_medium_unattempted,
        sum(case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'MODERATE' then a.duration end)/60000::float as application_medium_time_taken_mins,
        round(application_medium_correct+application_medium_incorrect/application_medium_time_taken_mins, 1) as application_medium_speed,
		round(application_medium_correct*100.0/(application_medium_correct+application_medium_incorrect),2) as application_medium_accuracy,

        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'TOUGH'
                                and a.answergiven is not null and a.answergiven = t.answer then t.id end) as application_hard_correct,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'TOUGH'
                                and a.answergiven is not null and a.answergiven != t.answer then t.id end) as application_hard_incorrect,
        count(distinct case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'TOUGH'
                                and a.answergiven is null then t.id end) as application_hard_unattempted,
        sum(case when t.skill in ('Application', 'Applications', 'Application ') and t.difficulty = 'TOUGH' then a.duration end)/60000::float as application_hard_time_taken_mins,
        round(application_hard_correct+application_hard_incorrect/application_hard_time_taken_mins, 1) as application_hard_speed,
		round(application_hard_correct*100.0/(application_hard_correct+application_hard_incorrect),2) as application_hard_accuracy,
        
        round(percent_rank() over (order by total_marks)*100.0, 2) as air,
        round(percent_rank() over (order by physics_total_marks)*100.0, 2) as physics_air,
        round(percent_rank() over (order by chemistry_total_marks)*100.0, 2) as chemistry_air,
        round(percent_rank() over (order by math_total_marks)*100.0, 2) as math_air,
        round(percent_rank() over (order by easy_total_marks)*100.0, 2) as easy_air,
        round(percent_rank() over (order by medium_total_marks)*100.0, 2) as medium_air,
        round(percent_rank() over (order by hard_total_marks)*100.0, 2) as hard_air,
        round(percent_rank() over (order by knowledge_total_marks)*100.0, 2) as knowledge_air,
        round(percent_rank() over (order by reasoning_total_marks)*100.0, 2) as reasoning_air,
        round(percent_rank() over (order by application_total_marks)*100.0, 2) as application_air,
        
        round(percent_rank() over (partition by u.locationinfo_state order by total_marks)*100.0, 2) as sir,
        round(percent_rank() over (partition by u.locationinfo_state order by physics_total_marks)*100.0, 2) as physics_sir,
        round(percent_rank() over (partition by u.locationinfo_state order by chemistry_total_marks)*100.0, 2) as chemistry_sir,
        round(percent_rank() over (partition by u.locationinfo_state order by math_total_marks)*100.0, 2) as math_sir,
        round(percent_rank() over (partition by u.locationinfo_state order by easy_total_marks)*100.0, 2) as easy_sir,
        round(percent_rank() over (partition by u.locationinfo_state order by medium_total_marks)*100.0, 2) as medium_sir,
        round(percent_rank() over (partition by u.locationinfo_state order by hard_total_marks)*100.0, 2) as hard_sir,
        round(percent_rank() over (partition by u.locationinfo_state order by knowledge_total_marks)*100.0, 2) as knowledge_sir,
        round(percent_rank() over (partition by u.locationinfo_state order by reasoning_total_marks)*100.0, 2) as reasoning_sir,
        round(percent_rank() over (partition by u.locationinfo_state order by application_total_marks)*100.0, 2) as application_sir
from Islcmdsquestion t
left join vsatquestionattempt as a on t.id = a.questionid
left join Islcmdstest ct on ct.id = a.testid
left join public.user u on u.id = a.studentid
left join cat_avg ca on ca.id = a.testid
left join cat_max cm on cm.testid = a.testid
where ct.id in ('605f30f7ec26197f10e752cd', '605f3e512aa0d93684f243ca')
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59)