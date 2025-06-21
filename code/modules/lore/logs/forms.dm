/obj/item/paper/form
	persist_on_init = FALSE

/obj/item/paper/form/blood_donation
	name = "Blood Donation Consent Form"
	info = "\
	<center><b>Blood Donation Informed Consent Form</b></center>\
	<hr>\
	Have you donated blood before? <field> <small>(yes/no)</small><br>\
	<hr>\
	<u>For Repeat Donors</u><br>\
	Did you encounter any problems in your last donation? <field>\
	<small>(No problems / fainting / bruise / difficulties finding vein / other)</small><br>\
	<hr>\
	Blood type: <field><br>\
	Date of Birth: <field> Sex: <field> Height: <field> Weight: <field><i>kg</i><br>\
	If more than 60 years old, do you have medical certificate? <field> <small>(yes/no)</small><br>\
	Occupation: <field><br>\
	Name: <i>Mr. / Ms. / Mrs.</i> <field> Signature: <field><br>\
	<hr>\
	<hr>\
	<center><b>For your own safety and the safety of the patient who will receive your blood, please answer the following questions, if applicable, to the best of your knowledge:</b></center>\
	<hr>\
	Category 1: <u>Obstetric History<small>(if applicable)</small></u><br>\
	1. Are you now or do you plan to become pregnant? <field><br>\
	2. Do you breastfeed? <field><br>\
	3. Have you given birth or miscarried in the last 6 months? <field><br>\
	<hr>\
	<u>Category 2</u>\
	4. Have you had diarrhea in the last 7 days? <field><br>\
	5. Have you undergone any surgery in the last 6 months? <field><br>\
	6. Do you drink alcohol? <field> If so, how many drinks do you have in a typical week? <field><br>\
	7. Do you have any history of drug addiction or have you been imprisoned in the last 3 years? <field><br>\
	8. Have you had a blood transfusion in the past 12 months? <field><br>\
	<u>Category 3</u>\
	9. Are you menstruating? <small>(if applicable)</small> <field><br>\
	10. Do you feel fit and well rested? <field><br>\
	11. What medication have you taken in the last 7 days? <field><br>\
	12. Do you have any history or family history of hepatitis? <field><br>\
	13. Do you have asthma, epilepsy, chronic skin disease, chronic cough, tuberculosis, allergies, high blood pressure, heart/kidney/thyroid disease, cancer, any bleeding disorder, or any communicable disease? <small>(please list which, if any, apply)</small> <field><br>\
	14. Have you had any body piercing, any tattoo applied or removed, or any acupuncture in the last 12 months? <field><br>\
	15. Have you had any vaccinations in the last 2 months? <field><br>\
	16. Other notes or issues: <field><br>\
	<hr>\
	<small>I certify that I have answered the above questions truthfully and that, to the best of my knowledge, my blood is safe for donation.\
	I have been informed that my blood will be tested for syphilis, hepatitis B and C, HIV, and other bloodborne illnesses.\
	I consent to donate blood without expecting any type of remuneration.\
	I accept that the blood I donate may be given to any patient or used for research purposes as deemed suitable.\
	I agree that the staff and technicians involved in my donations are not liable for any untoward effects that may occur after my donation.\
	</small>\
	Donor signature: <field><br>\
	Doctor/Staff signature: <field><br>"

/obj/item/paper/form/blood_donation/filled/Initialize(mapload, text, title, list/md)
	var/list/possible_patient_names = list(
		"Casey Rodrigez", "Eddie Hall", "Mia FLeurant", "Samuel Panibratow",
		"Sol Daud", "Bartholomew Edwards", "Ashley Jefferson", "Iuda Bergson", "Kollum Kille Katzman"
	)
	var/list/possible_doctor_names = list(
		"Aeon Vantablack", "Naomi Vexler", "Bartholomew Edwards", "Mia FLeaurant"
	)

	var/patient_name = pick(possible_patient_names)
	var/doctor_name = pick(possible_doctor_names)

	name = "Blood Donation Consent Form - [patient_name]"
	text = "\
	<center><b>Blood Donation Informed Consent Form</b></center>\
	<hr>\
	Have you donated blood before? yes <small>(yes/no)</small><br>\
	<hr>\
	<u>For Repeat Donors</u><br>\
	Did you encounter any problems in your last donation? no\
	<small>(No problems / fainting / bruise / difficulties finding vein / other)</small><br>\
	<hr>\
	Name: <i>Mr. / Ms. / Mrs.</i> [patient_name] Signature: <i>[patient_name]</i><br>\
	<hr>\
	<hr>\
	<center><b>For your own safety and the safety of the patient who will receive your blood, please answer the following questions, if applicable, to the best of your knowledge:</b></center>\
	<hr>\
	Category 1: <u>Obstetric History<small>(if applicable)</small></u><br>\
	1. Are you now or do you plan to become pregnant? <field><br>\
	2. Do you breastfeed? <field><br>\
	3. Have you given birth or miscarried in the last 6 months? <field><br>\
	<hr>\
	<u>Category 2</u>\
	4. Have you had diarrhea in the last 7 days? <field><br>\
	5. Have you undergone any surgery in the last 6 months? <field><br>\
	6. Do you drink alcohol? <field> If so, how many drinks do you have in a typical week? <field><br>\
	7. Do you have any history of drug addiction or have you been imprisoned in the last 3 years? <field><br>\
	8. Have you had a blood transfusion in the past 12 months? <field><br>\
	<u>Category 3</u>\
	9. Are you menstruating? <small>(if applicable)</small> <field><br>\
	10. Do you feel fit and well rested? <field><br>\
	11. What medication have you taken in the last 7 days? <field><br>\
	12. Do you have any history or family history of hepatitis? <field><br>\
	13. Do you have asthma, epilepsy, chronic skin disease, chronic cough, tuberculosis, allergies, high blood pressure, heart/kidney/thyroid disease, cancer, any bleeding disorder, or any communicable disease? <small>(please list which, if any, apply)</small> <field><br>\
	14. Have you had any body piercing, any tattoo applied or removed, or any acupuncture in the last 12 months? <field><br>\
	15. Have you had any vaccinations in the last 2 months? <field><br>\
	16. Other notes or issues: <field><br>\
	<hr>\
	<small>I certify that I have answered the above questions truthfully and that, to the best of my knowledge, my blood is safe for donation.\
	I have been informed that my blood will be tested for syphilis, hepatitis B and C, HIV, and other bloodborne illnesses.\
	I consent to donate blood without expecting any type of remuneration.\
	I accept that the blood I donate may be given to any patient or used for research purposes as deemed suitable.\
	I agree that the staff and technicians involved in my donations are not liable for any untoward effects that may occur after my donation.\
	</small>\
	Donor signature: <i>[patient_name]</i><br>\
	Doctor/Staff signature: <i>[doctor_name]</i><br>"

	. = ..()

/obj/item/paper/form/discharge
	name = "Blood Donation Consent Form"
	info = "\
	<u><center>Discharge from Medbay</center></u><br>\
	<br>\
	The discharged name: <field><br>\
	Was treated in the medbay for: <field><br>\
	Discharge date: <field><br>\
	Discharge reason: <field><br>\
	<br>\
	<hr><b>Treating Doctor</b>: <field><br>\
	<b>Signature</b>: <field><br>\
	<b>Date</b>: <field><br>\
	<hr><br>\
	"