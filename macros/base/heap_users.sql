{% macro heap_users() %}

    {{ adapter_macro('heap.heap_users') }}

{% endmacro %}

{% macro default__heap_users() %}

{%
    set window_clause = "partition by user_id order by last_modified rows
        between unbounded preceding and unbounded following"
%}

--this is only done because heap has a bug where it inserts duplicate records for users.

select distinct

    lower(user_id) as user_id,
    lower(last_value(
        {{heap.identity_field()}}
                ) over ( {{window_clause}} )) as user_identity,
    last_value(lower(email)) over ( {{window_clause}} ) as email,
    min(joindate) over ( {{window_clause}} ) as joindate,
    last_value(lower(phone_number)) IGNORE NULLS over ( {{window_clause}} ) as phone,
    last_value(emails_webinar_events) IGNORE NULLS over ( {{window_clause}} ) as emails_webinar_events,
    last_value(emails_new_features) IGNORE NULLS over ( {{window_clause}} ) as emails_new_features,
    last_value(emails_product_catalog) IGNORE NULLS over ( {{window_clause}} ) as emails_product_catalog,
    last_value(account) IGNORE NULLS over ( {{window_clause}} ) as company,
    last_value(integration_signup) IGNORE NULLS over ( {{window_clause}} ) as integration_signup,
    last_value(website_url) IGNORE NULLS over ( {{window_clause}} ) as website_url,
    last_value(first_name) IGNORE NULLS over ( {{window_clause}} ) as first_name,
    last_value(last_name) IGNORE NULLS over ( {{window_clause}} ) as last_name
    
from {{ source('heap', 'users') }}

{% endmacro %}