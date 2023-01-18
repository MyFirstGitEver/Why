class Obj
{
  int start, end;

  Obj(this.start, this.end);

  bool wraps(Obj o)
  {
    return (o.start >= start && o.end <= end);
  }
}

void main()
{
  File("D:\\advent.txt").readAsString().then((value) 
  {
    var list = IndexesOf(value, ":\"red\"");
    var objs = <Obj>[];

    for(int i=list.length - 1;i>=0;i--)
    {
      int pos = list[i];

      int start = 0;

      int p = pos;
      int checker = 1;

      while(true)
      {
        if(value[p] == '}')
          checker++;
        else if(value[p] == '{')
          checker--;

        if(checker == 0 && value[p] == '{')
          break;

        p--;
      }
      
      start = p;
      p = pos;
      
      checker = 1;
      while(true)
      {
        if(value[p] == '{')
          checker++;
        else if(value[p] == '}')
          checker--;

        if(checker == 0 && value[p] == '}')
          break;
        p++;
      }

      addNew(objs, Obj(start, p));
    }

    print(Count(value, 0, value.length) 
      - calcualteExclude(objs, value));
  });
}

int Count(String doc, int start, int end)
{
  int ans = 0;
  for(int i=start;i<end;i++)
  {
    if(doc.codeUnitAt(i) < 0x30 || doc.codeUnitAt(i) > 0x39)
      continue;

    StringBuffer buffer = StringBuffer();
    if(i != 0 && doc[i - 1] == '-')
      buffer.write('-');
    
    int p = i;
    while(doc.codeUnitAt(p) >= 0x30 && doc.codeUnitAt(p) <= 0x39)
    {
      buffer.write(doc[p]);
      p++;
    }
    
    ans += int.parse(buffer.toString());
    i = p - 1;
  }

  return ans;
}

List<int> IndexesOf(String doc, String term)
{
  var list = <int>[];

  int cursor = -term.length;

  while(true)
  {
    cursor = doc.indexOf(term, cursor + term.length);

    if(cursor == -1)
      break;
    list.add(cursor);
  }

  return list;
}

void addNew(List<Obj> list, Obj newObj)
{
  bool wrapped = false;

  for(int i=list.length - 1;i>=0;i--)
  {
    if(list[i].wraps(newObj))
    {
      wrapped = true;
      break;
    }
    else if(newObj.wraps(list[i]))
      list.removeAt(i);
  }

  if(!wrapped)
    list.add(newObj);
}

int calcualteExclude(List<Obj> list, String doc)
{
  int exclude = 0;

  for(Obj o in list)
    exclude += Count(doc, o.start, o.end);

  return exclude;
}

import 'dart:ffi';
import 'dart:io';
import 'dart:math';

class Fly
{
  int speed, flyTime, restTime, currentPoint = 0;
  
  Fly(this.speed, this.flyTime, this.restTime);
}

void main()
{
  var flies = <Fly>[];

  while(true)
  {
    String input = stdin.readLineSync().toString();

    if(input == "")
      break;

    flies.add(processInput(input));
  }

  int maxPoint = -1;

  for(int i=1;i<=2503;i++)
  {
    int maxDist = -1;

    for(Fly fly in flies)
    {
      maxDist = max(f(i, fly), maxDist);
    }

    for(Fly fly in flies)
    {
      if(f(i, fly) == maxDist)
      {
        fly.currentPoint++;
      }
    }
  }

  for(Fly fly in flies)
  {
    maxPoint = max(maxPoint, fly.currentPoint);
  }

  print(maxPoint);
}

Fly processInput(String input)
{
  var arr = [];

  for(int i=0;i<input.length;i++)
  {
    if(input.codeUnitAt(i) >= 0x30 && input.codeUnitAt(i) <= 0x39)
    {
      int p = i;
      StringBuffer buffer = StringBuffer();
      while(input.codeUnitAt(p) >= 0x30 && input.codeUnitAt(p) <= 0x39)
      {
        buffer.write(input[p]);
        p++;
      }

      String str = buffer.toString();

      if(str != "")
      {
        arr.add(int.parse(str));
        i = p - 1;
      }
    }
  }

  return Fly(arr[0], arr[1], arr[2]);
}

int f(int n, Fly fly)
{
  int cnt = n ~/ (fly.flyTime + fly.restTime);
  int left = n % (fly.flyTime + fly.restTime);

  int tempMin = min(left, fly.flyTime);

  return (cnt * fly.flyTime + tempMin) * fly.speed;
}

import 'dart:ffi';
import 'dart:io';
import 'dart:math';

const GRID_SIZE = 100;
const STEPS = 100;

void main()
{
  File("D:\\advent.txt").readAsString().then((result)
  {
    var arr = List.generate(GRID_SIZE, (i) => 
      List.filled(GRID_SIZE, true));

    var counters = List.generate(GRID_SIZE, (i) => 
      List.filled(GRID_SIZE, 0));

    var strings = result.split('\r\n');

    for(int i=0;i<strings.length;i++)
    {
      String input = strings[i];

      for(int j=0;j<input.length;j++)
      {
        if((i == 0 && j == 0) || (i == 0 && j == GRID_SIZE - 1) ||
            (i == GRID_SIZE - 1 && j == 0) || (i == GRID_SIZE - 1 && j == GRID_SIZE - 1))
            continue;

        if(input[j] == '#')
        {
          arr[i][j] = true;
        }
        else
        {
          arr[i][j] = false;
        }
      }
    }

    for(int a=0;a<STEPS;a++)
    {
      int i = 3;
      for(int i=0;i<GRID_SIZE;i++)
      {
        for(int j=0;j<GRID_SIZE;j++)
        {
          counters[i][j] = countNeighbors(i, j, arr);
        }
      }

      for(int i=0;i<GRID_SIZE;i++)
      {
        for(int j=0;j<GRID_SIZE;j++)
        {
          if((i == 0 && j == 0) || (i == 0 && j == GRID_SIZE - 1) ||
            (i == GRID_SIZE - 1 && j == 0) || (i == GRID_SIZE - 1 && j == GRID_SIZE - 1))
            continue;
          
          int cnt = counters[i][j];

          if(arr[i][j] && cnt != 2 && cnt != 3)
          {
            arr[i][j] = false;
          }
          else if(!arr[i][j] && cnt == 3)
          {
            arr[i][j] = true;
          }
        }
      }
    }

    int ans = 0;

    for(int i=0;i<GRID_SIZE;i++)
    {
      for(int j=0;j<GRID_SIZE;j++)
      {
        if(arr[i][j])
          ans++;
      }
    }

    print(ans);
  });
}

int countNeighbors(int x, int y, List<List<bool>> arr)
{
  int cnt = 0;

  for(int a=x-1;a<=x+1;a++)
  {
    for(int b=y-1;b<=y+1;b++)
    {
      if(getState(a, b, arr) && (a != x || b != y))
      {
        cnt++;
      }
    }
  }

  return cnt;
}

bool getState(int x, int y, List<List<bool>> arr)
{
  if(x < 0 || x == GRID_SIZE)
    return false;
  else if(y < 0 || y == GRID_SIZE)
    return false;
  else
    return arr[x][y];
}
