from os import replace


with open ('ks.csv', 'r') as in_file:
    records = in_file.readlines()
    
    for i in range(len(records)):
        records[i] = records[i].split(',')
        
        for h in ['', '\n']:
            while h in records[i][15:]:
                records[i].remove(h)


    with open('clean_ks.csv', 'w+') as out_file:
        for i in range(len(records)):
            while len(records[i]) != len(records[0]):
                records[i][1] += " " + records[i][2]
                del records[i][2]
            
            
            for h in range(len(records[i])):
                if h != 0:
                    out_file.write(',')
                out_file.write(records[i][h])
            out_file.write("\n")
    
        

              