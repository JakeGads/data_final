# Data Cleaning

The issue here is `,`, everyday people use ',' to separate information. In the english language it is used to pause in a sentence. People use it as a way to put emphasis in titles which people on KickStater people do a lot.

Because the data is stored as a Comma Separated Values (.csv) file, having commas in the data means the data gets confused about what goes in what column.

I used `python` to repair this issue

## Explaining the script

first we open up the original file and read the data in

count is included so I can count how many changes were necessary

```python
with open ('ks.csv', 'r') as in_file:
    records = in_file.readlines() # loads all records into a list split by new lines (currently strings)
    count = 0
```

We then opening up the file to write too and begin to edit the data

we then split on the ','

and prepare to remove anything that shouldn't be there like empty spaces or newlines

for the first 15 spaces we look to replace it with `N/A`

after that that is excess data and is removed from the data set entirely

```python
with open('clean_ks.csv', 'w+') as out_file: # opening an out file
    for i in range(len(records)): # loads through each record
        records[i] = records[i].split(',') # seperates the list by ,
        for illegal_char in ['', '\n']: # checks if there are any characters their shouldn't be (either a new line or an empty)
            while illegal_char in records[i][:15]: # while its in the valid range
                records[i][records[i].index(illegal_char)] = "N/A" # replace with a /n
            while illegal_char in records[i][15:]: #while its past the maximum
                records[i].remove(illegal_char) # removes the characters past the limit
```

now we get rid of those pesky extra `,`

we know that the title is in the second col (list location 1), hence we can just check to see if the list is slightly too long and if it is we just take those 2 concatenate them and then delete whatever is n 2 and let it sync back.

```python
        while len(records[i]) != len(records[0]): # checks if it is the proper size
            records[i][1] += " " + records[i][2]  # if its not appends the split tittle
            del records[i][2] # deletes the other (shifts everything back)
            count += 1
```

then in the final step we just write out what we have to the file

```python
        for h in range(len(records[i])): # goes through the entire record
            if h != 0: # skips the first so it doesn't add a first ','
                out_file.write(',')
            out_file.write(records[i][h]) # writes out the actual record 
        out_file.write("\n") # adds a \n to denote a new record

```