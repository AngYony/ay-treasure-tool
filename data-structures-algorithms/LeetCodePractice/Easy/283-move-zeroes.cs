﻿using System;

namespace Easy
{
    /// <summary>
    /// LeetCode:283. 移动零
    /// </summary>
    public class MoveZeroes
    {
        /// <summary>
        /// 单层循环遍历原创
        /// </summary>
        /// <param name="nums"></param>
        public static void MoveZeroes1(int[] nums)
        {
            //输入: [0, 1, 0, 3, 12]
            //输出: [1, 3, 12, 0, 0]

            int j = 0;

            for (int i = 0; i < nums.Length; i++)
            {
                if (nums[i] != 0)
                {
                    nums[j] = nums[i];
                    if (i > j)
                    {
                        nums[i] = 0;
                    }
                    j++;
                }
            }
        }

        public static void Run()
        {
            int[] nums = new[] { 1, 0 };

            MoveZeroes1(nums);
            foreach (var n in nums)
            {
                Console.WriteLine(n);
            }
        }
    }
}