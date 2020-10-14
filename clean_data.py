try:
	import tqdm
	
	# opens up the raw data file
	with open ('ks.csv', 'r') as in_file:
		records = in_file.readlines() # loads all records into a list split by new lines (currently strings)
		count = 0
		with open('clean_ks.csv', 'w+') as out_file: # opening an out file
		    for i in tqdm.tqdm(range(len(records)), "processing"): # loads through each record
		        records[i] = records[i].split(',') # seperates the list by ,
		        for illegal_char in ['', '\n']: # checks if there are any characters their shouldn't be (either a new line or an empty)
		            while illegal_char in records[i][:15]: # while its in the valid range
		                records[i][records[i].index(illegal_char)] = "N/A" # replace with a /n
		            while illegal_char in records[i][15:]: #while its past the maximum
		                records[i].remove(illegal_char) # removes the characters past the limit


		        while len(records[i]) != len(records[0]): # checks if it is the proper size
		            records[i][1] += " " + records[i][2]  # if its not appends the split tittle
		            del records[i][2] # deletes the other (shifts everything back)
		            count += 1

		        for h in range(len(records[i])): # goes through the entire record
		            if h != 0: # skips the first so it doesn't add a first ','
		                out_file.write(',')
		            out_file.write(records[i][h]) # writes out the actual record 
		        out_file.write("\n") # adds a \n to denote a new record
		
	print(count, "changes made")
except :
    # opens up the raw data file
    with open ('ks.csv', 'r') as in_file:
        records = in_file.readlines() # loads all records into a list split by new lines (currently strings)
        count = 0
        with open('clean_ks.csv', 'w+') as out_file: # opening an out file
            for i in range(len(records)): # loads through each record
                records[i] = records[i].split(',') # seperates the list by ,
                for illegal_char in ['', '\n']: # checks if there are any characters their shouldn't be (either a new line or an empty)
                    while illegal_char in records[i][:15]: # while its in the valid range
                        records[i][records[i].index(illegal_char)] = "N/A" # replace with a /n
                    while illegal_char in records[i][15:]: #while its past the maximum
                        records[i].remove(illegal_char) # removes the characters past the limit


                while len(records[i]) != len(records[0]): # checks if it is the proper size
                    records[i][1] += " " + records[i][2]  # if its not appends the split tittle
                    del records[i][2] # deletes the other (shifts everything back)
                    count += 1

                for h in range(len(records[i])): # goes through the entire record
                    if h != 0: # skips the first so it doesn't add a first ','
                        out_file.write(',')
                    out_file.write(records[i][h]) # writes out the actual record 
                out_file.write("\n") # adds a \n to denote a new record
        
    print(count, "changes made")
