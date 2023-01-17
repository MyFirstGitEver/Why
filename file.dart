import 'dart:io';

void main()
{
  // ab, cd, pq, or xy
  const arr = ["ab", "cd", "pq", "xy"];
  int ans = 0;

  while(true)
  {
    String str = stdin.readLineSync().toString();

    if(str == "")
      break;

    int vowelCnt = 0;
    bool duplicate = false, disallowed = false;
  
    for(var string in arr)
    {
      if(str.contains(string))
      {
        disallowed = true;
        break;
      }
    }
  
    for(int i=0;i<str.length;i++)
    {
      switch(str[i])
      {
        case 'e':
        case 'u':
        case 'o':
        case 'a':
        case 'i':
          vowelCnt++;
          break;
      }
    }
  
    for(int i=0;i<str.length - 1;i++)
    {
      if(str[i] == str[i + 1])
      {
        duplicate = true;
        break;
      }
    }
  
    if(vowelCnt >= 3 && duplicate && !disallowed)
      ans++;
    else
      print("-> ${str}");
  }

  print(ans);
}
