using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Medium
{
    /// <summary>
    /// 127. 单词接龙
    /// </summary>
    public class WordLadder
    {


        public int LadderLength(String beginWord, String endWord, IList<string> wordList)
        {
            if (!wordList.Contains(endWord)) return 0;

            HashSet<string> beginSet = new HashSet<string>(), endSet = new HashSet<string>();

            int len = 1;
            int strLen = beginWord.Length;
            HashSet<string> visited = new HashSet<string>();

            beginSet.Add(beginWord);
            endSet.Add(endWord);
            while (beginSet.Any() && endSet.Any())
            {
                if (beginSet.Count > endSet.Count)
                {
                    HashSet<string> set = beginSet;
                    beginSet = endSet;
                    endSet = set;
                }

                HashSet<string> temp = new HashSet<string>();
                foreach (string word in beginSet)
                {
                    char[] chs = word.ToCharArray();

                    for (int i = 0; i < chs.Length; i++)
                    {
                        for (char c = 'a'; c <= 'z'; c++)
                        {
                            char old = chs[i];
                            chs[i] = c;
                            String target = new string(chs);

                            if (endSet.Contains(target))
                            {
                                return len + 1;
                            }

                            if (!visited.Contains(target) && wordList.Contains(target))
                            {
                                temp.Add(target);
                                visited.Add(target);
                            }
                            chs[i] = old;
                        }
                    }
                }

                beginSet = temp;
                len++;
            }

            return 0;
        }



        public int LadderLength2(string beginWord, string endWord, IList<string> wordList)
        {
            // IList<string> dict = new List<string>(wordList);
            IList<string> qs = new List<string>();
            IList<string> qe = new List<string>();
            IList<string> vis = new List<string>();

            qs.Add(beginWord);

            if (wordList.Contains(endWord))
                qe.Add(endWord);

            for (int len = 2; qs.Any(); len++)
            {
                List<string> nq = new List<string>();
                foreach (string w in qs)
                {
                    for (int j = 0; j < w.Length; j++)
                    {
                        char[] ch = w.ToCharArray();
                        for (char c = 'a'; c <= 'z'; c++)
                        {
                            if (c == w[j])
                                continue;

                            ch[j] = c;
                            string nb = new string(ch);

                            if (qe.Contains(nb))
                                return len;
                            if (wordList.Contains(nb))
                            {
                                vis.Add(nb);
                                nq.Add(nb);
                            }
                        }
                    }
                }
                qs = (nq.Count() < qe.Count()) ? nq : qe;
                qe = (qs == nq) ? qe : nq;
            }
            return 0;
        }



        public int LadderLength3(String beginWord, String endWord, List<String> wordList)
        {
            HashSet<String> wordSet = new HashSet<string>(wordList); //替换掉题目中List结构，加速查找

            if (!wordList.Contains(endWord)) return 0; //如果目标顶点不在图中，直接返回0

            //用来存储已访问的节点，并存储其在路径上的位置，相当于BFS算法中的isVisted功能
            Dictionary<string, int> dic = new Dictionary<string, int>();


            Queue<String> q = new Queue<string>(); //构建队列，实现广度优先遍历
            q.Enqueue(beginWord); //加入源顶点

            dic.Add(beginWord, 1); //添加源顶点为“已访问”，并记录它在路径的位置
            while (q.Any())
            { //开始遍历队列中的顶点
                String word = q.Dequeue(); //记录现在正在处理的顶点
                int level = dic[word]; //记录现在路径的长度
                for (int i = 0; i < word.Length; i++)
                {
                    char[] wordLetter = word.ToCharArray();
                    for (char j = 'a'; j <= 'z'; j++)
                    {
                        if (wordLetter[i] == j) continue;
                        wordLetter[i] = j; //对于每一位字母，分别替换成另外25个字母
                        String check = new string(wordLetter);
                        if (check.Equals(endWord)) return dic[word] + 1; //如果已经抵达目标节点，返回当前路径长度+1
                        if (wordList.Contains(check) && !dic.ContainsKey(check))
                        { //如果字典中存在邻接节点，且这个邻接节点还未被访问
                            dic.Add(check, level + 1); //标记这个邻接节点为已访问，记录其在路径上的位置
                            q.Enqueue(check); //加入队列，以供广度搜索
                        }
                    }
                }
            }
            return 0;
        }

    }
}
