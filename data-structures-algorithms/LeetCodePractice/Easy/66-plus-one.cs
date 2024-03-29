﻿using System;

namespace Easy
{
    public class PlusOne
    {
        /// <summary>
        /// 66. 加一
        /// </summary>
        /// <param name="digits"></param>
        /// <returns></returns>
        public static int[] PlusOne1(int[] digits)
        {
            //        输入: [1, 9, 9]
            //输出: [2, 0, 0]
            //if (digits[0] == 0) return new [] { 1 };

            for (int i = digits.Length - 1; i >= 0; i--)
            {
                if (++digits[i] >= 10)
                {
                    digits[i] = 0;
                }
                if (digits[i] != 0) return digits;
            }

            digits = new int[digits.Length + 1];
            digits[0] = 1;
            return digits;
        }

        public static void Run()
        {
            //int[] nums = { 1, 2, 3, 4, 5, 6, 7, 8 };
            int[] nums = { 1, 9, 9 };

            int[] n2 = PlusOne1(nums);
            foreach (var n in n2)
            {
                Console.WriteLine(n);
            }
        }
    }
}