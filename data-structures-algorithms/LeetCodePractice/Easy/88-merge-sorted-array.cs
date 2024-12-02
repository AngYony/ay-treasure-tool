﻿using System;

namespace Easy
{
    /// <summary>
    /// LeetCode:88. 合并两个有序数组
    /// </summary>
    public class MergeSortedArray
    {
        /// <summary>
        /// 方法一：暴力求解法
        /// </summary>
        /// <param name="nums1"></param>
        /// <param name="m"></param>
        /// <param name="nums2"></param>
        /// <param name="n"></param>
        public static void Merge(int[] nums1, int m, int[] nums2, int n)
        {
            nums2.CopyTo(nums1, m);
            Array.Sort(nums1);
        }

        public static void Run()
        {
            int[] nums1 = new[] { 1, 2, 3, 4, 0, 0, 0 };
            int[] nums2 = new[] { 2, 3 };

            Merge(nums1, 3, nums2, 3);
            foreach (var n in nums1)
            {
                Console.WriteLine(n);
            }
        }
    }
}