from threading import Thread
from pytictoc import TicToc

def threadAdd(list_one, list_two, list_three, index):
    list_three[index] = list_one[index] + list_two[index]
    
def main():
    list_size = 214748365 #int max / 10
    list_one = [2 for x in range(list_size)]
    list_two = [3 for x in range(list_size)]
    list_three = [0 for x in range(list_size)]
    threads = []

    t = TicToc() ## TicToc("name")
    t.tic();
    for i in range(list_size):
        thread = Thread(target=threadAdd, args=[list_one, list_two, list_three, i])
        thread.start()
        threads.append(thread)

    for thread in threads:
        thread.join()

    t.toc();
    print(t.elapsed)
    print(list_three)
    
 
if __name__ == '__main__':
    main()
