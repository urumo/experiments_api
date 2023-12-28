select e.key,
       e.value,
       count(e.value)                                           as amount,
       total_devices.count                                      as total_devices,
       round((count(e.value) * 100.0 / total_devices.count), 3) as actual_percent,
       e.chance
from devices d
         left join device_experiments de on d.id = de.device_id
         left join experiments e on de.experiment_id = e.id,
     (select count(*) as count from devices) as total_devices
group by e.key, e.value, e.chance, total_devices.count
order by e.chance desc