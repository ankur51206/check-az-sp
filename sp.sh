#!/bin/bash 


az ad app list --query [].{AppId:appId} -o table > appid

sed -i -e '1,2d' appid


while IFS= read  -r line;
do

echo $line >> sp.txt
az ad app credential list --id $line --query [].{endDate:endDate} -o tsv >> sp.txt
echo  "--------------------------------------------" >> sp.txt
echo "" >> sp.txt
sleep 1
done < appid

