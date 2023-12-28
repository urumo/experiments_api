select e.id,
       e.key,
       e.value,
       count(e.value)                                           as amount,
       total_devices.count                                      as total_devices,
       round((count(e.value) * 100.0 / total_devices.count), 3) as percent_of_total,
       key_devices.count                                        as key_devices,
       round((count(e.value) * 100.0 / key_devices.count), 3)   as percent_of_key,
       e.chance
from devices d
         left join device_experiments de on d.id = de.device_id
         left join experiments e on de.experiment_id = e.id,
     (select count(*) as count from devices) as total_devices,
     (select e.key, count(*) as count
      from devices d
               left join device_experiments de on d.id = de.device_id
               left join experiments e on de.experiment_id = e.id
      where e.key is not null
      group by e.key) as key_devices
where e.key is not null
  and e.key = key_devices.key
group by e.key, e.value, e.chance, total_devices.count, key_devices.count, e.id
order by e.chance desc