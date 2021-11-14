

.PHONY: Madsand 

Madsand: CSV=csv/Colleges.csv
Madsand: UPDATE=Madsand/update.txt 
Madsand: ENDING=Madsand/ending.txt 
Madsand: LINK="https://www.youtube.com/watch?v=wE8n5TZKkVo" 
Madsand: SUBJECT="Georgie Worley - 2023 Blocker/Split Blocker 5'11 - Madsand Tournament Update" 
Madsand: SIGNATURE=Madsand/signature.txt
Madsand: 
	perl generate -email -nickname -csv ${CSV} -update ${UPDATE} -ending ${ENDING} -link ${LINK} -subject ${SUBJECT} -signature ${SIGNATURE}

