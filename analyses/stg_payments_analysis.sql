with source as (

    select * from {{ source('stripe', 'raw_payments') }}

),

payments as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status,

-- amount is in cents, convert it to dollars via a macro

        {{ cents_to_dollars('amount', 4) }} as amount,
        created as created_at

    from source

)

select
    status,
    sum(amount)
from payments
group by 1
order by 2 desc
