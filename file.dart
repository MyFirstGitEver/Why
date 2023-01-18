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
