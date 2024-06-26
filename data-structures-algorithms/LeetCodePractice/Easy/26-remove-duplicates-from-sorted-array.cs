﻿using System;

namespace Easy
{
    /// <summary>
    /// LeetCode:26. 删除排序数组中的重复项
    /// </summary>
    public class RemoveDuplicatesFromSortedArray
    {
        /// <summary>
        /// 双指针法
        /// </summary>
        /// <param name="nums"></param>
        /// <returns></returns>
        public static int RemoveDuplicates2(int[] nums)
        {
            //1,2,3,3,2,2,4=>1,2,3,2,4
            if (nums.Length == 0) return 0;

            int i = 0;
            for (int j = 1; j < nums.Length; j++)
            {
                if (nums[j] != nums[i])
                {
                    i++;
                    nums[i] = nums[j];
                }
            }
            return i + 1;
        }

        /// <summary>
        /// 扩展题目： 1,2,3,3,2,2,4=>1,2,3,4
        /// </summary>
        /// <param name="nums"></param>
        /// <returns></returns>
        public static int RemoveDuplicates(int[] nums)
        {
            //nums ={ 1,  1, 2 };
            if (nums.Length == 0)
                return 0;
            int a = 1;
            bool skip = false;
            for (int i = 1; i < nums.Length; i++)
            {
                skip = false;
                for (int j = 0; j < a; j++)
                {
                    if (nums[i] == nums[j])
                    {
                        skip = true;
                        break;
                    }
                }
                if (!skip)
                {
                    nums[a] = nums[i];
                    a++;
                }
            }
            return a;
        }

        public static void Run()
        {
            int[] nums = { 1, 2, 2, 1, 4 };
            RemoveDuplicates2(nums);
            foreach (var n in nums)
            {
                Console.WriteLine(n);
            }
        }
    }
}