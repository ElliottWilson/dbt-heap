{% macro heap_events() %}

    {{ adapter_macro('heap.heap_events') }}

{% endmacro %}


{% macro default__heap_events() %}

with events as
(
    select 
        
        *,
        {{heap.time_field('event_time')}},
        row_number() over (partition by event_id order by time) as row_number
        
    from {{ source('heap', 'all_events') }}
)

select
    event_id,
    time,
    user_id,
    session_id,
    event_table_name,
    event_time
from events
-- add row number filter to remove duplicate rows
where row_number = 1

{% endmacro %}