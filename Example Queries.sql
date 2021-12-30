-- Flavio Miranda 
select unique emp_id, asset_make, asset_model, asset_type_id, asset_ext
from jaherna42.it_asset ia join jaherna42.ci_inventory ci 
on ia.asset_id = ci.asset_id
join jaherna42.employee_ci ec on ec.ci_inv_id = ci.ci_in_id 
where ia.asset_type_id = 1 or ia.asset_type_id = 3; 


-----------------------------------------------------
Select unique asset_type_id, asset_make, asset_model, num_assgnd_user 
from JAHERNA42.it_asset ia join jaherna42.it_asset_inv_summary its
on ia.asset_id = its.asset_id
where its.num_assgnd_user >= 1 and ia.asset_type_id = 1 or ia.asset_type_id= 3;
----------------------------
select first_name,
last_name,
ci_inv_id,
user_or_support
from JAHERNA42.employee
right outer join JAHERNA42.employee_ci on employee.emp_id = employee_ci.emp_id;
--------------------------
select asset_make,
asset_model,
num_available,
inv_summary_date
from JAHERNA42.it_asset a
inner join jaherna42.it_asset_inv_summary b on a.asset_id = b.asset_id
where (b.num_available) > 5
order BY asset_make, num_available asc;
---------------------------------------------------
select line_item_description, ili.account_number, v.vendor_name, i.invoice_number
from jdoe22.invoice_line_items ili
join jdoe22.invoices i on ili.invoice_id = i.invoice_id
join jdoe22.vendors v on v.vendor_id = i.vendor_id
where v.vendor_name like '%Costco%' and to_char(i.invoice_date, 'MON-RR') = 'AUG-21';
-----------------------------------------------------
select sysdate - invoice_due_date as "how long", invoice_id, invoice_total, credit_total
from jdoe22.invoices 
where payment_date is null and sysdate - invoice_due_date > 30;
-------------------------------------------------------
select i.account_number, account_description
from jdoe22.general_ledger_accounts g
full join jdoe22.invoice_line_items i
on g.account_number = i.account_number
where i.account_number is null;
-------------------------------------------------------
select v.vendor_name, sum(i.payment_total)
from jdoe22.vendors v join jdoe22.invoices i 
on v.vendor_id = i.vendor_id
group by vendor_name  
order by sum(payment_total) desc;
