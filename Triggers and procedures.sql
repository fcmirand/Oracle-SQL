--Flavio Miranda
create or replace trigger department_before_update_state
before insert or update of dept_code
on department
for each row 
when (new.dept_code != upper(new.dept_code))
begin
  :new.dept_code := upper(:new.dept_code);
end;
--------------------------------------------------
create or replace trigger vendors_before_update_state
before insert or update  of vendor_state
on vendors 
for each row 
when (new.vendor_state != upper(new.vendor_state))
begin 
:new.vendor_state := upper(:new.vendor_state);
end;
create or replace trigger Computer_trigger
before insert or update of asset_id
on computer
for each row
declare
asset_id_char varchar2(32767);
begin
  select asset_type_desc
  into asset_id_char
  from asset_type a join it_asset ia on 
  a.asset_type_id = ia.asset_type_id
  where ia.asset_id = :new.asset_id;
  if asset_id_char != 'Computer' then
    RAISE_APPLICATION_ERROR(-20001,'Only assets that are computers can be in the computer table.');    
  end if;
end;
------------------------------------------------------------------------
create or replace procedure findasset
(gotcha out jaherna42.it_asset.asset_make%type)
as
ran_val number(10);
smallest number(10);
largest number(10);
begin
--The first select statement is choosing the highest asset_id and then dividing it by 10,000. 
--It then Rounds the asset_id and stores it into the variable called largest. 
select round(max(asset_id)/10000,0) into largest from jaherna42.it_asset;
--State what the next command does.
select min(asset_id) into smallest from jaherna42.it_asset;
--State what the next command does.
select round(dbms_random.value(smallest,largest),0)
    into ran_val from dual;
--State what the next command does.
select distinct asset_make into gotcha
from jaherna42.it_asset where asset_id = ran_val;
exception
when others then 
gotcha:= 'Could not find the asset';
end;

declare 
getit varchar2(32767) := 'Hello!';
begin
findasset(getit);
dbms_output.put_line(getit);
end;
------------------------------------------
-- Simple view 
CREATE or replace VIEW vw_vendors_min_info
AS
SELECT vendor_name,vendor_state,
vendor_phone FROM jdoe22.vendors;

select * from vw_vendors_min_info;

create or replace view not_paid
as
select invoice_date, invoice_number, invoice_total, 'not_paid' as status 
from jdoe22.invoices where invoice_total-payment_total-credit_total > 0
and invoice_date between sysdate - 30 and sysdate;
-------------------------------------------
create or replace view balance_due_view
as
select vendor_name, invoice_number, invoice_total,
payment_total,credit_total,
invoice_total-payment_total-credit_total
as balance_due from
vendors v join invoices i
on v.vendor_id = i.vendor_id
where invoice_total - payment_total - credit_total > 0
with check option;
