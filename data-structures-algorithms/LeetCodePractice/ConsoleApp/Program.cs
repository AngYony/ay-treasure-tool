using Medium;
using System;

namespace ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {

            //Easy.RemoveDuplicatesFromSortedArray.Run();

            // Easy.RotateArray.Run();

            //Easy.MergeSortedArray.Run();

            //Easy.MoveZeroes.Run();

            //Easy.PlusOne.Run();


            //Easy.ValidAnagram.Run();
            //Medium.GroupAnagrams.Run();

            //Easy.TwoSum.Run();

            //int a = "Dev_Allocation_EMEA".GetHashCode();
            //Console.WriteLine(a.ToString());


            WordLadder wl = new WordLadder();
int a=       wl.LadderLength3("hit", "cog", new System.Collections.Generic.List<string> { "hot","dot","dog","lot","log" });
            Console.WriteLine(a.ToString());


            Console.ReadLine();

        }
    }
}
