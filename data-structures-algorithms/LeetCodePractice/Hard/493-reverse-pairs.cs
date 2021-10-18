using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hard
{
    /// <summary>
    /// 493. 翻转对
    /// </summary>
    public class ReversePairs
    {
        public int reversePairs(int[] nums)
        {
            return mergeSort(nums, 0, nums.Length - 1);
        }
        private int mergeSort(int[] nums, int s, int e)
        {
            if (s >= e) return 0;
            int mid = s + (e - s) / 2;
            int cnt = mergeSort(nums, s, mid) + mergeSort(nums, mid + 1, e);
            for (int i = s, j = mid + 1; i <= mid; i++)
            {
                while (j <= e && nums[i] / 2.0 > nums[j]) j++;
                cnt += j - (mid + 1);
            }
            Array.Sort(nums, s, e + 1);
            return cnt;
        }
    }
}
