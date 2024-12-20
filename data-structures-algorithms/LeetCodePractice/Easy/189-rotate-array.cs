﻿using System;

namespace Easy
{
    /// <summary>
    /// LeetCode:189,输入: [1,2,3,4,5,6,7] 和 k = 3,输出: [5,6,7,1,2,3,4]
    /// </summary>
    public class RotateArray
    {
        /// <summary>
        /// 方法一（原创）：使用单个循环，先将起始元素A存储起来，然后找目标元素B，将B的值写入到A的位置，然后再找B元素的目标元素C，依次类推：A->B,B->C,C->D,D=A
        /// </summary>
        /// <param name="nums"></param>
        /// <param name="k"></param>
        public static void Rotate(int[] nums, int k)
        {
            int len = nums.Length;
            k = k > len ? k % len : k;
            int current = 0; //当前需要计算的元素的索引
            int t = 0;
            int temp = nums[t]; //保存第一个元素的值

            int count = 0; //循环计数器

            while (count < len)
            {
                if (-k + current == t)
                {
                    nums[current] = temp;
                    t++;
                    current = t;
                    if (t < len)
                    {
                        temp = nums[t];
                    }
                }
                else
                {
                    //判断目标元素是否在当前元素的左边
                    if (-k + current > 0)
                    {
                        nums[current] = nums[-k + current];
                        current = -k + current;
                    }
                    else
                    {
                        //计算当前元素的值的来源
                        nums[current] = nums[len - k + current];
                        //将目标元素设置为当前需要计算的元素，下一次循环的时候，找设置后的元素的来源，依次内推
                        current = len - k + current;
                    }
                }

                count++;
            }
        }

        /// <summary>
        /// 方法二：双重循环
        /// </summary>
        /// <param name="nums"></param>
        /// <param name="k"></param>
        public static void Rotate2(int[] nums, int k)
        {
            int temp, end;
            for (int i = 0; i < k; i++)
            {
                end = nums[nums.Length - 1]; //获取最后一个元素
                for (int j = 0; j < nums.Length; j++)
                {
                    temp = nums[j];
                    nums[j] = end;
                    end = temp;
                }
            }
        }

        public static void Run()
        {
            //int[] nums = { 1, 2, 3, 4, 5, 6, 7, 8 };
            int[] nums = { -1, -100, 3, 99 };

            Rotate(nums, 2);
            foreach (var n in nums)
            {
                Console.WriteLine(n);
            }
        }
    }
}