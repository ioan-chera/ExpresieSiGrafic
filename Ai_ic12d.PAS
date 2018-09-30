{$N+}
program expresie_si_grafic_ioan_chera;
uses graph, crt;
label 1, 2, 3;
const
     barh=444;
     barh2=12;
     titlu='Expresie  si  grafic';
     titluaj='Indicatii de folosire pentru "Expresie si grafic"';
     graftitlu='+ COMANDA DE DESENARE GRAFICE +';
     orizsimplu=196;
     orizdublu=205;
     susstangasimplu=218;
     susstangadublu=201;
     susdreaptasimplu=191;
     susdreaptadublu=187;
     josstangasimplu=192;
     josstangadublu=200;
     josdreaptasimplu=217;
     josdreaptadublu=188;
     punctcentru=254;
     vertsimplu=179;
     vertdublu=186;
     has1=176;
     has2=177;
     has3=178;
     has4=219;
     sageatastanga=17;
     sageatadreapta=16;
var
   wndmax, wndmin:word;

   goto1_g:boolean;

   memexpr:array[1..10]of string;
   memrez:array[1..10]of extended;
   ultmem:1..10;
   catemem:0..10;
   pozo:array[1..9]of byte;
   oales:1..9;

   gdriver,gmode:integer;
   origmode:integer;
   g_rezx1,g_rezx2,g_rezy1,g_rezy2:byte;
   g_tabx1,g_tabx2,g_taby1,g_taby2:byte;
   culfond:byte;

   cul:array[1..10] of byte;    {set de culori pentru 10 grafice}
   calc:boolean;

   expr_g,ver_g:string; {variabile globale}
   func:array[1..10] of string;    {aici se copiaza din expr_g cele cel mult}
   nfunc:integer;                    {10 functii}
   eroare_g:boolean;
    i_g,j_g,k_g:integer;
    valide,cifre,paranteze,litere,plusminus,virgule,operatori:set of char;
      {multimi de semne permise}

    pst,pdr,ps,pj,nox,noy:extended;     {parametri de ecran}
    centx,desty,centy,unx,uny:extended;
    ri,rj:extended;
    scr:string;
    numit:integer;
    rez_g,pozy,pozx:extended;
    che:char;                {tasta}
    cod_g:integer;

    PROCEDURE ajutor;
    var i:integer;
    begin
        textbackground(7);
        textcolor(0);
        window(lo(wndmin)+1, hi(wndmin)+1, lo(wndmax)+1, hi(wndmax)+1);
        clrscr;

        write(chr(susstangadublu));
        for i:=1 to lo(wndmax)-1 do write(chr(orizdublu));
        write(chr(susdreaptadublu));
        write(chr(vertdublu));
        gotoxy(lo(wndmax)+1, 2);
        write(chr(vertdublu));
        write(chr(vertdublu));
        gotoxy((lo(wndmax)+1)div 2 - length(titluaj)div 2, 3);
        write(titluaj);
        gotoxy(lo(wndmax)+1, 3);
        write(chr(vertdublu));
        write(chr(vertdublu));
        gotoxy(lo(wndmax)+1, 4);
        write(chr(vertdublu));
        write(chr(josstangadublu));
        for i:=1 to lo(wndmax)-1 do write(chr(orizdublu));
        write(chr(josdreaptadublu));

        textcolor(1);
        gotoxy(5, 8);
        write('Introduceti in tabla de comenzi o operatie matematica. Puteti folosi ope-');
        gotoxy(3, 10);
        write('ratorii +, -, *, / si parantezele de  asociere  a  termenilor (factorilor):');
        gotoxy(3, 12);
        write('(, ), oricate niveluri sunt necesare. Parantezele drepte si acoladele nu se');
        gotoxy(3, 14);
        write('intrebuinteaza.');
        gotoxy(5, 17);
        textcolor(0);
        write('EXEMPLU de comanda-operatie: ');
        textcolor(1);
        write('(2+sin(3))/((1+cos(2))*(tg(22)-ctg(sin(44))))');
        gotoxy(5, 20);
        write('Dupa cum vedeti, am folosit functii. Programul accepta cateva functii ma-');
        gotoxy(3, 22);

        write('tematice. Ele sunt: ');
        textcolor(0);
        gotoxy(3, 24);
        write(chr(punctcentru), ' p(x,y) -- x la puterea lui y;');
        gotoxy(45, 24);
        write(chr(punctcentru), ' rad(x) -- radical din x;');
        gotoxy(3, 25);
        write(chr(punctcentru), ' rad(x,y) -- radical ordin y din x;');
        gotoxy(45, 25);
        write(chr(punctcentru), ' log(y,x) -- logaritm baza y de x;');
        gotoxy(3, 26);
        write(chr(punctcentru), ' ln(x) -- logaritm natural de x;');
        gotoxy(45, 26);
        write(chr(punctcentru), ' lg(x) -- logaritm zecimal de x;');
        gotoxy(3, 27);
        write(chr(punctcentru), ' sin(x) -- sinus de x;');
        gotoxy(45, 27);
        write(chr(punctcentru), ' cos(x) -- cosinus de x;');
        gotoxy(3, 28);
        write(chr(punctcentru), ' tg(x) -- tangent de x;');
        gotoxy(45, 28);
        write(chr(punctcentru), ' ctg(x) -- cotangent de x;');
        gotoxy(3, 29);
        write(chr(punctcentru), ' arcsin(x) -- arcsinus de x;');
        gotoxy(45, 29);
        write(chr(punctcentru), ' arccos(x) -- arccosinus de x;');
        gotoxy(3, 30);
        write(chr(punctcentru), ' arctg(x) -- arctangent de x;');
        gotoxy(45, 30);
        write(chr(punctcentru), ' arcctg(x) -- arccotangent de x;');
        gotoxy(3, 31);
        write(chr(punctcentru), ' int(x) -- partea intreaga a lui x;');
        gotoxy(3, 32);
        write(chr(punctcentru), ' frac(x) -- partea fractionara a lui x;');
        gotoxy(45, 31);
        write(chr(punctcentru), ' abs(x) -- modul de x;');
        gotoxy(45, 32);
        write(chr(punctcentru), ' fact(n) -- n factorial;');
        gotoxy(3, 33);
        write(chr(punctcentru), ' aranj(m,n) -- aranjamente de m cate n;');
        gotoxy(3, 34);
        write(chr(punctcentru), ' comb(m,n) -- combinari de m cate n;');
        gotoxy(3, 35);
        write(chr(punctcentru), ' mod(x,y) -- restul impartirii x:y;');
        gotoxy(3, 36);
        write(chr(punctcentru), ' s(n1,n2,f(#1)) -- suma cu #1 de la n1 la n2 din f(#1);');
        gotoxy(3, 37);
        write(chr(punctcentru), ' pr(n1,n2,f(#1)) -- produs, acelasi algoritm.');


        textcolor(1);
        gotoxy(5, 39);
        write('Desigur, literele si f()-urile din paranteze trebuie inlocuite cu expresii.');

        gotoxy(5, 42);
        write('In calcule se accepta si semnele: ^ (pi); & (e); @ (variabila  functiei,');
        gotoxy(3, 43);
        write('relevanta pt. grafice) si #1, #2 etc. (variabilele iteratiilor din S si PR).');


        gotoxy(5, 45);


        textcolor(0);
        write('EXEMPLE de expresii folosind semne: ');
        textcolor(1);
        write                                    ('sin(^/12)');
        textcolor(0);
        write                                             (', ');
        textcolor(1);
        write                                               ('p(&,3)');
        textcolor(0);
        write                                                     ('.');

        textcolor(1);
        gotoxy(5, 47);
        write('Iata o alta comanda-expresie: ');
        textcolor(0);
        write                              ('PR(1,5,S(1,#1,#1*#2))');
        textcolor(1);
        write(                                                   '.  #1 va  fi  iteratia');
        gotoxy(3, 48);
        write('functiei din fata (pr), iar #2 a celei imbricate (s).  Numerotatia e  nece-');
        gotoxy(3, 49);
        write('sara pentru apartenenta fiecarei variabile la functia corecta.');

        readkey;

    end;

    PROCEDURE decoreaza;
    var i,j:integer;
    begin
     textbackground(0);
     clrscr;
     gotoxy(1,1);

     textbackground(1);
     textcolor(0);

     wndmax:=windmax;
     wndmin:=windmin;
     {primele doua randuri, albastre}
     for j:=0 to lo(wndmax)div 2 do begin write(chr(orizsimplu)); end;
     for j:=0 to lo(wndmax)div 2 do begin write(chr(orizsimplu)); end;
     textcolor(15);
     for j:=0 to lo(wndmax)div 2 do begin write(chr(orizdublu)); end;
     for j:=0 to lo(wndmax)div 2 do begin write(chr(orizdublu)); end;


     textbackground(4);
     textcolor(14);
     {titlul in flacari}
     for i:=1 to (lo(wndmax)+1)div 2 - length(titlu)div
         2 - 14 do write(chr(has1));
     for i:=1 to 14 do write(' ');
     write(titlu);
     for i:=1 to 14 do write(' ');
     for i:=wherex to lo(wndmax)+1 do write(chr(has1));
     for i:=1 to (lo(wndmax)+1)div 2 - length(titlu)div
         2 - 7 do write(chr(has1));
     for i:=wherex to lo(wndmax)-wherex+1 do write(' ');
     for i:=wherex to lo(wndmax)+1 do write(chr(has1));


     for i:=1 to lo(wndmax)div 2 - 7 do write(chr(has2));
     for i:=wherex to lo(wndmax)-wherex+1 do write(' ');
     for i:=wherex to lo(wndmax)+1 do write(chr(has2));
     for i:=1 to lo(wndmax)+1 do write(chr(has3));

     for i:=0 to lo(wndmax) do write(chr(has4));
     textbackground(0);
     textcolor(15);
     for i:=0 to lo(wndmax) do write(chr(orizdublu));
     for i:=0 to lo(wndmax)div 16 do write('\ / \ / --/ --- ');
     for i:=0 to lo(wndmax)div 16 do write(' |   |   /   |  ');
     for i:=0 to lo(wndmax)div 16 do write('/ \  |  /--  |  ');
     for i:=0 to lo(wndmax) do write(chr(orizdublu));

     {fondul albastrui}
     culfond:=randoM(6)+1;
     textbackground(culfond);
     textcolor(0);
     for i:=wherey-1 to hi(wndmax)-1 do
         for j:=0 to lo(wndmax)div 4 do
             write(chr(has1), '  ', chr(has1));

     gotoxy(1,hi(wndmax)+1);
     textcolor(1);
     textbackground(0);
     write('Proiect pentru Atestat la informatica, mai 2008, C.N. "Lazar", Ioan CHERA, 12D');

     textbackground(culfond);
     textcolor(15);

     gotoxy(4,14);
     write('Rezultate:');

     {fereastra de date de iesire}
     window(4,15, 3*(lo(wndmax)+1)div 4+1, hi(wndmax)-10);
     g_rezx1:=lo(windmin)+2;
     g_rezx2:=lo(windmax);
     g_rezy1:=hi(windmin)+2;
     g_rezy2:=hi(windmax)-2;

     write(chr(susstangasimplu));
     for i:=1 to lo(windmax)-lo(windmin)-1 do write(chr(orizsimplu));
     write(chr(susdreaptasimplu));
     for i:=wherey to hi(windmax)-hi(windmin)-2 do begin
         write(chr(vertsimplu));
         textbackground(0);
         for j:= 1 to lo(windmax)-lo(windmin)-1 do write(' ');
         textbackground(culfond);
         write(chr(vertsimplu));
     end;
     write(chr(josstangasimplu));
     for i:=1 to lo(windmax)-lo(windmin)-1 do write(chr(orizsimplu));
     write(chr(josdreaptasimplu));

     {rescrie-le}
     window(g_rezx1, g_rezy1, g_rezx2, g_rezy2);
     textbackground(0);

     gotoxy(1,hi(windmax)-hi(windmin)+1);
     for i:=1 to catemem do begin
         textcolor(12);
         j:=ultmem-catemem+i-1;
         if j<0 then inc(j,10);
         write(memexpr[j + 1], '=');
         textcolor(15);
         writeln(memrez[j + 1]:6:10);
         writeln;
     end;

     textbackground(culfond);

     {restart fereastra}
     window(1+lo(wndmin),1+hi(wndmin),1+lo(wndmax),1+hi(wndmax));

     {etichete}
     textcolor(11);
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, 15);
     for i:=1 to 17 do write(chr(orizsimplu));
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, 16);
     write('Pentru indicatii,');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, 17);
     for i:=1 to 17 do write(' ');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, 18);
     write('tastati cuvantul');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, 19);
     for i:=1 to 17 do write(' ');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, 20);
     write('AJ, apoi ENTER.');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, 21);
     for i:=1 to 17 do write(chr(orizsimplu));

     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-24);
     for i:=1 to 17 do write(chr(orizsimplu));
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-23);
     write('Pentru grafice,  ');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-22);
     for i:=1 to 17 do write(' ');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-21);
     write('folositi cuv. GR.');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-20);
     for i:=1 to 17 do write(chr(orizsimplu));

     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-16);
     for i:=1 to 17 do write(chr(orizsimplu));
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-15);
     write('Pentru iesire,  ');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-14);
     for i:=1 to 17 do write(' ');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-13);
     write('scrieti EX.     ');
     gotoxy(3*(lo(wndmax)+1)div 4 + 3, hi(wndmax)-12);
     for i:=1 to 17 do write(chr(orizsimplu));

     gotoxy(2, hi(wndmax)-5);
     textcolor(14);
     write('Tabla de comenzi:');
     textcolor(15);
     window((lo(wndmax)+1)div 4-1, hi(wndmax)-6, 3*(lo(wndmax)+1)div 4+3,
                                  hi(wndmax)-1);
     write(chr(susstangadublu));
     for i:=1 to lo(windmax)-lo(windmin)-1 do write(chr(orizdublu));
     write(chr(susdreaptadublu));
     for i:=1 to 3 do begin
         write(chr(vertdublu));
         textbackground(0);
         for j:= 1 to lo(windmax)-lo(windmin)-1 do write(' ');
         textbackground(culfond);
         write(chr(vertdublu));
     end;
     write(chr(josstangadublu));
     for i:=1 to lo(windmax)-lo(windmin)-1 do write(chr(orizdublu));
     write(chr(josdreaptadublu));
     textbackground(0);
     window(lo(windmin)+2, hi(windmin)+2, lo(windmax), hi(windmax)-1);
     g_tabx1:=lo(windmin)+1;
     g_tabx2:=lo(windmax)+1;
     g_taby1:=hi(windmin)+1;
     g_taby2:=hi(windmax)+1;
    end;

    PROCEDURE grafic;
    var i,j:integer;
        ver:string;
    begin
        calc:=false;
        window(lo(wndmin)+1, hi(wndmin)+13, lo(wndmax)+1, hi(wndmax)+1);
        culfond :=2;
        textbackground(culfond);
        clrscr;

        for i:=1 to hi(windmax)-hi(windmin) do begin
            write(chr(has2), chr(has1), chr(has1));
            if (i=6) or (i=7) or (i=31) or (i=32) or (i=34) or (i=35) then
               for j:=1 to lo(wndmax)-4 do
                   write(chr(orizsimplu))
            else if (i=33) then begin
                 textcolor(4);
                 write('P,RAD,LOG...,SIN...,ARCSIN...,INT,FRAC,ABS,FACT,ARANJ,COMB,MOD,S,PR,^,&');
                 textcolor(15);
            end;
            writeln;
        end;

        textcolor(4);

        gotoxy((lo(wndmax) + 1)div 2 - length(graftitlu)div 2, 1);
        write(graftitlu);

        textcolor(1);
        gotoxy(4,3);
        write('FOLOSITI SEMNUL @ PENTRU VARIABILA FUNCTIEI.');
        gotoxy(4,5);
        textcolor(0);
        write('EXEMPLU: s(0,5,p(@,#1)/fact(#1))');

        gotoxy(4,hi(windmax)-hi(windmin)-1);
        textcolor(1);
        write('COMENZI: ');
        textcolor(0);
        write(         'GA');
        textcolor(1);
        write(           ' -- incheie interogarea; ');
        textcolor(0);
        write(                                    'RE1, RE2...');
        textcolor(1);
        write(                                               ' -- rescrie functia 1, 2...');
        gotoxy(4,hi(windmax)-hi(windmin));
        textcolor(0);
        write('EX');
        textcolor(1);
        write(  ' -- anulare, intoarcere la ecranul initial.');

        window(5, 21, lo(wndmax)-1, 41);

        textcolor(15);
        for i:=1 to 10 do begin
            gotoxy(1,2*i-1);
            str(i, ver);

            write('Functia ',ver,': ');
        end;

        textcolor(0);
        j:=-1;
        nfunc:=-1;
        for i:=1 to 10 do begin
            gotoxy(1,2*i);
            clreol;
            gotoxy(12,2*i-1);
            clreol;
            readln(func[i]);
            if (upcase(func[i][1])='G')and(upcase(func[i][2])='A')then
            begin
                 nfunc:=i-1;
                 i:=10;
                 j:=-1;
            end;
            if j<>-1 then begin
               i:=j-1;
               j:=-1;
            end;
            if(upcase(func[i][1])='R')and(upcase(func[i][2])='E')
                 and (ord(func[i][3])>=ord('1'))
                 and (ord(func[i][3])<=ord('9')) then begin
                 j:=i;
                 i:=ord(func[i][3])-ord('1');
            end;
            if(upcase(func[i][1])='E')and(upcase(func[i][2])='X')then
            begin
                 window(1,1,lo(wndmax)+1,hi(wndmax)+1);
                 goto1_g:=true;
                 i:=10;
            end;

        end;
        if nfunc=-1 then
           nfunc:=10;


    end;

    PROCEDURE CONTROL(var expr:string);{"controlul" expresiei brute, filtrarea}
    var niv,i,j,l:integer;
        mul:set of char;
        ver:string;
        ultsemn:char;
    BEGIN
         l:=length(expr);
         ultsemn:=' ';

         for i:=1 to l do       {stergerea tuturor semnelor nepermise}
             while (i<=l) and not (upcase(expr[i]) in valide) do
             begin
                  delete(expr, i, 1);
                  l:=l - 1;
             end;
         ultsemn:=' ';
         niv:=0;
         for i:=1 to l do
         begin
              if (ultsemn = ' ') or (ultsemn = '(')
              or (ultsemn in operatori) or (ultsemn = ',') then
                 mul:=cifre+['(']+litere+plusminus
              else if ultsemn in cifre then
                   mul:=cifre+virgule+operatori+[')']
              else if upcase(ultsemn) in litere then
                   mul:=['(']+litere
              else if ultsemn = '.' then
                   mul:=cifre
              else if ultsemn = ')' then
                   mul:=operatori+[')',',']; {stergerea erorilor de sintaxa}

              while (i<=l) and not (upcase(expr[i]) in mul) do
              begin
                   delete(expr, i, 1);
                   l:=l - 1;
              end;
              ultsemn:=expr[i];
              if ultsemn = '(' then
                 niv:=niv+1
              else if ultsemn = ')' then
                   niv:=niv-1;
              while (niv < 0) and (expr[i] = ')') and (i<=l) do
              begin
                   if (expr[i] <> ')') then
                      niv:=niv+1;
                   delete(expr, i, 1); {stergerea parantezelor excesive}
                   l:=l - 1
              end;
              ultsemn:=expr[i]
         end;
         while niv>0 do
         begin
              niv:=niv - 1;
              insert(')',expr,l+1); {adaugarea parantezelor "uitate"}
              l:=l + 1
         end;

         for i:=1 to l do
         begin
              if upcase(expr[i]) in litere then
              begin
                   j:=i;
                   ver:='';
                   while upcase(expr[j]) in litere do
                   begin
                        insert(upcase(expr[j]), ver, length(ver)+1);
                        j:=j+1
                   end; {stergerea cuvintelor nerecunoscute}
                   if (ver<>'P')and(ver<>'LOG')and(ver<>'LN')
                   and(ver<>'LG')and(ver<>'SIN')and(ver<>'COS')
                   and(ver<>'TG')and(ver<>'CTG')and(ver<>'INT')
                   and(ver<>'FRAC')and(ver<>'ABS')and(ver<>'RAD')
                   and(ver<>'ARCSIN')and(ver<>'ARCCOS')and(ver<>'ARCTG')
                   and(ver<>'ARCCTG')and(ver<>'FACT')and(ver<>'ARANJ')
                   and(ver<>'COMB')and(ver<>'MOD')and(ver<>'S')
                   and(ver<>'PR') then
                                    while (upcase(expr[i]) in litere) and (i <= l) do
                                    begin
                                         delete(expr, i, 1);
                                         l:=l - 1
                                    end
                   else
                       i:=i + length(ver) - 1
              end
         end
    END;

    {functie pentru factorial}
    function factorial(n:longint):extended;
    var i:longint;
        r:extended;
    begin
         r:=1;
         for i:=2to n do r:=r*i;
             factorial:=r;
    end;
                          {executa functia factorial}
    function aranjamente(a,b:longint):extended;
    begin
         aranjamente:=factorial(a)/factorial(a-b)
    end;

    function combinari(a,b:longint):extended;{executa functia factorial}
    var p1,p2,i:longint;
    begin
         if b>a-b then
            combinari:=combinari(a,a-b)
         else
             combinari:=factorial(a)/factorial(b)/factorial(a-b);
    end;
        {alternativa pentru operatorul MOD care permite si numere "reale"}
    function modulo(n1, n2:extended):extended;
    begin
         while n1>=n2 do
               n1:=n1 - n2;
         while n1<0 do
               n1:=n1 + n2;
         modulo:=n1;
    end;

    procedure curata(var expr:string);  {alt tip de filtrare: stergerea}
    var p:byte; gasit:boolean;          {spatiilor si a semnelor}
    begin                               {excesive produse de inlocuirea}
         p:=pos(' ',expr);              {subexpresiilor cu rezultatele}
         while p<>0 do
         begin
              delete(expr, p, 1);
              p:=pos(' ',expr)
         end;

         repeat
               gasit:=false;
               p:=pos('++',expr);
               while p>0 do begin
                     delete(expr,p,1);
                     p:=pos('++',expr);
                     gasit:=true;
               end;
               p:=pos('+-',expr);
               while p>0 do begin
                     delete(expr,p,1);
                     p:=pos('+-',expr);
                     gasit:=true;
               end;
               p:=pos('-+',expr);
               while p>0 do begin
                     delete(expr,p+1,1);
                     p:=pos('-+',expr);
                     gasit:=true;
               end;
               p:=pos('--',expr);
               while p>0 do begin
                     delete(expr,p,2);
                     insert('+',expr,p);
                     p:=pos('--',expr);
                     gasit:=true;
               end;
         until gasit=false;
    end;
    {functie alternativa pentru INT: Pascal nu stie ca INTul negativelor este
             <=}
    function intreg(v:extended):extended;
    begin
         intreg:=v;
         if v>=0 then
            intreg:=int(v)
         else if int(v)<>v then
             intreg:=int(v)-1
    end;
    {parte fractionara}
    function fract(v:extended):extended;
    begin
         fract:=v-intreg(v)
    end;
                       {functia principala de evaluare}
    function eval(expr:string; inloc:extended; parm:boolean; cep:extended; nivel:word):extended;
    var i,j,k,l,niv,nmax,nma,nmv,nmv2,nmb:integer;
        rez,v1,v2:extended;
        necautat:boolean;
        ver:string;
        op:char;
        cod,latern:integer;
        inloc2:string;
        poz:integer;
    begin

         poz:=pos('^',expr);                    {pi}
         while poz>0 do begin
               delete(expr,poz,1);
               str(pi,inloc2);
               insert(inloc2,expr,poz);
               curata(expr);
               poz:=pos('^',expr);
         end;


         poz:=pos('&',expr);                        {e}
         while poz>0 do begin
               delete(expr,poz,1);
               str(exp(1),inloc2);
               insert(inloc2,expr,poz);
               curata(expr);
               poz:=pos('&',expr);
         end;
          poz:=pos('@', expr);                         {x}
          while poz > 0 do begin
                delete(expr, poz, 1);
                str(inloc, inloc2);
                insert(inloc2, expr, poz);

                curata(expr);
                poz:=pos('@', expr);
          end;
          if parm then begin                              {k sau i}
             str( nivel, ver);
             poz:=pos('#'+ver, expr);                         {iteratie}
             while poz>0 do begin
                   delete(expr,poz,1+length(ver));
                   str(cep,inloc2);
                   insert(inloc2,expr,poz);

                   curata(expr);
                   poz:=pos('#'+ver,expr);
             end;
          end;

          rez:=0;
         necautat:=true;
         repeat
               l:=length(expr);
               niv:=0;
               nma:=0;
               nmb:=0;
               nmax:=0;
               latern:=-1;
               for i:=1 to l do
               begin    {atentie daca este functie si functia este S sau Pr}
                    if expr[i]='(' then    {atunci nu inainta}
                    begin
                         niv:=niv+1;
                         ver:='';
                         j:=i-1;
                         while (j>0) and (upcase(expr[j]) in litere) do
                         begin
                              insert(upcase(expr[j]),ver,1);
                              j:=j-1;
                         end;
                         if (niv>=nmax)and (latern=-1) then
                         begin
                              nmax:=niv;
                              nma:=i+1
                         end;
                         if (ver='S')or(ver='PR')then
                            latern:=niv;
                    end
                    else if expr[i]=')' then
                    begin
                         if niv=nmax then
                            nmb:=i-1;
                         if niv=latern then
                            latern:=-1;
                         niv:=niv-1
                    end
               end;
               if (nma>0) and (nmb>0) then
               begin
                    l:=0;
                    if (nma>=3) and (upcase(expr[nma-2]) in litere) then
                    begin
                         i:=nma-2;
                         ver:='';
                         while (i>0) and (upcase(expr[i]) in litere) do
                         begin
                              insert(upcase(expr[i]),ver,1);
                              i:=i-1;
                         end;
                         l:=length(ver);

                        if ver='P' then {putere (folosesc exp(b*ln(a))}
                        begin      {multe exceptii de rezolvat}
                             i:=nma;
                             nmv:=-1;
                             while i<=nmb do
                             begin
                                  if expr[i]=',' then
                                  begin
                                       nmv:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             if nmv=-1 then begin
                                v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                                v2:=0
                             end else begin
                                v2:=eval(copy(expr,nmv+1,nmb-nmv),inloc,false,0,nivel);
                                v1:=eval(copy(expr,nma,nmv-nma),inloc,false,0,nivel);
                             end;

                             if (v1=0) and (v2<=0) then eroare_g:=true
                             else if (v1=0) and (v2>0) then rez:=0
                             else if (v1<0) then begin
                                if v2=abs(int(v2)) then begin
                                   rez:=1;
                                   if v2*ln(-v1)/ln(10)>4000 then
                                      eroare_g:=true
                                   else
                                   for i:=1 to round(v2) do
                                   begin
                                       rez:=rez*v1;
                                   end
                                end else if v2=int(v2) then begin
                                    rez:=1;
                                    if ln(-v1)/-v2/ln(10)>4000 then
                                       eroare_g:=true
                                    else
                                    for i:=1 to round(abs(v2)) do
                                    begin
                                        rez:=rez/v1;
                                    end
                                end else
                                    eroare_g:=true
                             end else
                                 if v2*ln(v1)/ln(10)>4000 then
                                    eroare_g:=true
                                 else
                                     rez:=exp(v2*ln(v1))

                        end
                        else if ver='RAD' then {exp(ln(a)/b), paradoxal}
                        begin                  {mai putin problematic}
                             i:=nma;
                             nmv:=-1;
                             while i<=nmb do
                             begin
                                  if expr[i]=',' then
                                  begin
                                       nmv:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             if nmv=-1 then begin
                                v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                                v2:=2
                             end else begin
                                 v1:=eval(copy(expr,nma,nmv-nma), inloc,false,0,nivel);
                                 v2:=eval(copy(expr,nmv+1,nmb-nmv),inloc,false,0,nivel);
                             end;
                             if v2=0 then eroare_g:=true
                             else if v1<0 then
                                  if v2<>int(v2) then
                                     eroare_g:=true
                                  else if round(v2)mod 2 = 0 then
                                       eroare_g:=true
                                  else
                                      rez:=-exp(ln(-v1)/v2)
                             else if v1=0 then
                                  rez:=0
                             else
                                 if ln(v1)/ln(10)/v2>4000 then
                                    eroare_g:=true
                                 else
                                     rez:=exp(ln(v1)/v2)
                        end
                        else if ver='LOG' then
                        begin
                             i:=nma;
                             nmv:=-1;
                             while i<=nmb do
                             begin
                                  if expr[i]=',' then
                                  begin
                                       nmv:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;

                             if nmv=-1 then begin
                                v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                                v2:=1
                             end else begin
                                 v1:=eval(copy(expr,nma,nmv-nma), inloc,false,0,nivel);
                                 v2:=eval(copy(expr,nmv+1,nmb-nmv), inloc,false,0,nivel);
                             end;
                             if (v1<=0)or(v2<=0)or(v1=1)then
                                eroare_g:=true
                             else
                                 rez:=ln(v2)/ln(v1)
                        end
                        else if ver='LN' then begin
                             v1:=eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel);
                             if v1<=0 then
                                eroare_g:=true
                             else
                                rez:=ln(v1)
                        end
                        else if ver='LG' then begin
                             v1:=eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel);
                             if v1<=0 then
                                eroare_g:=true
                             else
                                rez:=ln(v1)/ln(10)
                        end
                        else if ver='SIN' then
                             rez:=sin(eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel))
                        else if ver='COS' then
                             rez:=cos(eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel))
                        else if ver='TG' then begin
                             v1:=eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel);
                             if cos(v1)=0 then
                                eroare_g:=true
                             else
                                rez:=sin(v1)/cos(v1)
                        end
                        else if ver='ARCTG' then
                             rez:=arctan(eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel))
                        else if ver='ARCCTG' then
                             rez:=pi/2-arctan(eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel))
                        else if ver='ARCSIN' then begin
                             v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                             if(v1<-1)or(v1>1)then
                                 eroare_g:=true
                             else if v1=1 then
                                  rez:=pi/2
                             else if v1=-1 then
                                  rez:=-pi/2
                             else
                                 rez:=arctan(v1/sqrt(1-v1*v1));
                        end
                        else if ver='ARCCOS' then begin
                             v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                             if(v1<-1)or(v1>1)then
                                 eroare_g:=true
                             else if v1=1 then
                                  rez:=0
                             else if v1=-1 then
                                  rez:=pi
                             else
                                 rez:=pi/2-arctan(v1/sqrt(1-v1*v1));
                        end
                        else if ver='CTG' then begin
                             v1:=eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel);
                             if sin(v1)=0 then
                                eroare_g:=true
                             else
                                rez:=cos(v1)/sin(v1)
                        end
                        else if ver='INT' then
                             rez:=intreg(eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel))
                        else if ver='FRAC' then
                             rez:=fract(eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel))
                        else if ver='ABS' then
                             rez:=abs(eval(copy(expr,nma,nmb-nma+1), inloc,false,0,nivel))
                        else if ver='FACT' then begin
                             v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                             if (abs(v1-abs(int(v1))) > 0.01)or(v1>1700) then
                                eroare_g:=true
                             else
                                 rez:=factorial(round(v1));
                        end
                        else if ver='ARANJ' then begin
                             i:=nma;
                             nmv:=-1;
                             while i<=nmb do
                             begin
                                  if expr[i]=',' then
                                  begin
                                       nmv:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             if nmv=-1 then begin
                                v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                                v2:=0
                             end
                             else begin
                                 v2:=eval(copy(expr,nmv+1,nmb-nmv),inloc,false,0,nivel);
                                 v1:=eval(copy(expr,nma,nmv-nma),inloc,false,0,nivel);
                             end;
                             if (abs(v1-abs(int(v1))) > 0.01)or
                                (abs(v2-abs(int(v2))) > 0.01)or
                                (v2>v1)or(v2>1700)or(v1>1700)then
                                eroare_g:=true
                             else
                                 rez:=aranjamente(round(v1),round(v2));
                        end
                        else if ver='COMB' then begin
                             i:=nma;
                             nmv:=-1;
                             while i<=nmb do
                             begin
                                  if expr[i]=',' then
                                  begin
                                       nmv:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             if nmv=-1 then begin
                                v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                                v2:=0
                             end
                             else begin
                                 v2:=eval(copy(expr,nmv+1,nmb-nmv),inloc,false,0,nivel);
                                 v1:=eval(copy(expr,nma,nmv-nma),inloc,false,0,nivel);
                             end;
                             if (abs(v1-abs(int(v1))) > 0.01)or
                                (abs(v2-abs(int(v2))) > 0.01)or
                                (v2>v1)or(v2>1700)or(v1>1700)then
                                eroare_g:=true
                             else
                                 rez:=combinari(round(v1),round(v2));
                        end
                        else if ver='MOD' then begin
                             i:=nma;
                             nmv:=-1;
                             while i<=nmb do
                             begin
                                  if expr[i]=',' then
                                  begin
                                       nmv:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             if nmv=-1 then begin
                                v1:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                                v2:=1
                             end
                             else begin
                                 v2:=eval(copy(expr,nmv+1,nmb-nmv),inloc,false,0,nivel);
                                 v1:=eval(copy(expr,nma,nmv-nma),inloc,false,0,nivel);
                             end;

                             if v2<0then begin
                                v2:=-v2;
                                v1:=-v1
                             end;
                             if v2=0then
                                eroare_g:=true
                             else
                                 rez:=modulo(v1, v2);

                        end
                        else if ver='S' then begin
                             i:=nma;
                             while i<=nmb do
                             begin
                                  if expr[i]=',' then
                                  begin
                                       nmv:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             i:=nmv+1;
                             while i<=nmb do
                             begin
                                  if expr[i]=','then
                                  begin
                                       nmv2:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             v1:=eval(copy(expr,nma,nmv-nma),inloc,false,0,nivel);
                             v2:=eval(copy(expr,nmv+1,nmv2-nmv-1),inloc,false,0,nivel);
                             if(abs(v1-int(v1))>0.01)or(abs(v2-int(v2))>0.01)
                               or(v2<v1)then
                                            eroare_g:=true
                               else begin   {dureaza mai mult executia aici}
                                    rez:=0; {si la PR}
                                    for i:=round(v1)to round(v2) do
                                    begin
                                        rez:=rez+eval(copy(expr,nmv2+1,nmb-nmv2),inloc,true,i,nivel+1);
                                        if abs(rez)>=1e+4500 then
                                        begin
                                             eroare_g:=true;
                                             rez:=0;
                                             i:=round(v2);
                                        end
                                    end
                               end
                        end
                        else if ver='PR' then begin
                             i:=nma;
                             while i<=nmb do
                             begin
                                  if expr[i]=',' then
                                  begin
                                       nmv:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             i:=nmv+1;
                             while i<=nmb do
                             begin
                                  if expr[i]=','then
                                  begin
                                       nmv2:=i;
                                       i:=nmb
                                  end;
                                  i:=i+1;
                             end;
                             v1:=eval(copy(expr,nma,nmv-nma),inloc,false,0,nivel);
                             v2:=eval(copy(expr,nmv+1,nmv2-nmv-1),inloc,false,0,nivel);
                             if(abs(v1-int(v1))>0.01)or(abs(v2-int(v2))>0.01)
                               or(v2<v1)then
                                            eroare_g:=true
                               else begin
                                    rez:=1;
                                    for i:=round(v1)to round(v2) do begin
                                        rez:=rez*eval(copy(expr,nmv2+1,nmb-nmv2),inloc,true,i,nivel+1);
                                        if abs(rez)>=1e+4500 then
                                        begin
                                             eroare_g:=true;
                                             rez:=0;
                                             i:=round(v2);
                                        end
                                    end
                               end
                        end
                  end
                  else  {nicio functie: evaluare directa, rezultatul asa cum
                        este}
                      rez:=eval(copy(expr,nma,nmb-nma+1),inloc,false,0,nivel);
                  str(rez,ver);
                  if l<>0 then
                  begin
                       delete(expr,nma-1-l,nmb-nma+3+l);
                       insert(ver,expr,nma-1-l);
                  end
                  else
                  begin
                       delete(expr,nma-1,nmb-nma+3);
                       insert(ver,expr,nma-1);
                  end;
                  Curata(expr); {stergerea spatiilor cauzate de numerele no-
                                tate stiintific de motorul Pascal}
              end
              else
              begin
                   necautat:=false;
                   l:=length(expr);
                   i:=1;
                   while i<=l do begin
                       op:=expr[i];   {mai intai multiplicativele}
                       if (op='*')or(op='/')then
                       begin
                            j:=i-1;
                            while (j<>0) and ((not(expr[j]in operatori)) or ((j>=2) and
                                  not (expr[j-1]in cifre))) do
                                 j:=j-1;
                            val(copy(expr,j+1,i-j-1),v1,cod);

                            k:=j+1;
                            j:=i+1;
                            while (j<>l+1)and ((not(expr[j]in operatori)) or ((j>=2) and
                                  not(expr[j-1]in cifre))) do
                                  j:=j+1;
                            val(copy(expr,i+1,j-i-1),v2,cod);

                            case op of
                                 '*':rez:=v1*v2;
                                 '/':begin if v2=0 then eroare_g:=true else rez:=v1/v2; end;
                            end;

                            str(rez,ver);
                            delete(expr,k,j-k);
                            insert(ver,expr,k);
                            i:=k;
                            l:=length(expr);
                            Curata(expr);
                       end;
                       i:=i+1
                   end;
                   l:=length(expr);
                   i:=1;
                   while i<=l do begin
                       op:=expr[i];   {din fericire se are grija de negative:
                                      Pascal le identifica si prin Val}
                       if((op='-')or(op='+'))and((i=1)or
                       (expr[i-1]<>'E'))then begin
                            j:=i-1;
                            while (j<>0) and ((not(expr[j]in operatori)) or ((j>=2) and
                                  not(expr[j-1]in cifre))or (j=1)) do
                                 j:=j-1;

                            val(copy(expr,j+1,i-j-1),v1,cod);

                            k:=j+1;
                            j:=i+1;
                            while (j<>l+1) and ((not(expr[j]in operatori)) or ((j>=2) and
                                  not(expr[j-1]in cifre))) do
                                  j:=j+1;

                            val(copy(expr,i+1,j-i-1),v2,cod);

                            case op of
                                 '+':begin rez:=v1+v2; end;
                                 '-':begin rez:=v1-v2; end;
                            end;
                            str(rez,ver);
                            delete(expr,k,j-k);
                            insert(ver,expr,k);
                            i:=k;
                            l:=length(expr);
                            Curata(expr);

                       end;
                       i:=i+1;
                   end
              end
         until not necautat;

         val(expr,rez,cod);
         eval:=rez;
    end;
{PROGRAM PRINCIPAL}
begin

     valide:=['1'..'9','0','@','#','^','*','(',')','-','+','&','A'..'Z',',','.','/'];
     cifre:=['1'..'9','0','@','#','^','&'];{adica semnele respective pot}
     paranteze:=['(',')'];                 {aparea si-n locul cifrelor, cum}
     litere:=['A'..'Z'];                   {ar fi 2^ <=> 23.1415...}
     plusminus:=['+','-'];                 {nerecomandat}
     virgule:=[',','.'];                 {au roluri bine stabilite si dis-}
     operatori:=['+','-','*','/'];       {tincte}
     cul[1]:=15;
     cul[2]:=14;
     cul[3]:=13;
     cul[4]:=11;
     cul[5]:=10;
     cul[6]:=9;
     cul[7]:=5;
     cul[8]:=3;
     cul[9]:=2;
     cul[10]:=4;
     randomize;
     ultmem:=10;
     catemem:=0;
     goto1_g:=false;

while 1=1 do begin
1:    {am folosit etichete pentru a evita o modificare masiva de program;
      etichetele oricum au fost puse in ultima clipa}
     origmode:=lastmode;
     textmode(C80 + Font8x8);

     Decoreaza;




2:
     readln(expr_g);

     if (upcase(expr_g[1])='E')and(upcase(expr_g[2])='X')then begin
        textmode(origmode);
         halt;
     end;
     if (upcase(expr_g[1])='A')and(upcase(expr_g[2])='J')then begin
        ajutor;
        goto 1;
     end;

     calc:=true;
     if (upcase(expr_g[1])='G')and(upcase(expr_g[2])='R')then begin
        grafic;
        if goto1_g then
        begin
             goto1_g:=false;
             goto 1;
        end;
     end else begin     {calc.}
         nfunc:=1;
         func[1]:=expr_g
     end;



     for k_g:=1 to nfunc do begin
         CONTROL(func[k_g]);
     end;

     if calc then begin
        eroare_g:=false;
        rez_g:=eval(func[1], 0,false,0,0);
        window(g_rezx1, g_rezy1, g_rezx2, g_rezy2);
        gotoxy(1,hi(windmax)-hi(windmin)+1);

        textcolor(12);

        write(func[1], '=');
        if eroare_g then
           writeln('Eroare in calcul')
        else begin

            textcolor(15);
            writeln(rez_g:6:10);
            writeln;
        end;

        if not eroare_g then begin
           if ultmem=10 then ultmem:=1 else inc(ultmem);
           memexpr[ultmem]:=func[1];
           memrez[ultmem]:=rez_g;
           if catemem<10 then inc(catemem);
        end else eroare_g:=false;

        textcolor(15);
        window(g_tabx1, g_taby1, g_tabx2, g_taby2);
        clrscr;
        goto 2;
     end
     else begin

     textbackground(0);
     clrscr;

     textcolor(12);
     gotoxy(3,3);

     write('Distanta origine-stanga ecranului: ');

     oales:=1;
     textcolor(9);
     pozo[1]:=wherex;
     write(chr(sageatadreapta));
     textcolor(15);
     write(' 40.00');

     pst:=40;


     gotoxy(3,5);
     textcolor(12);
     write('Distanta origine-dreapta ecranului: ');

     textcolor(15);
     pozo[2]:=wherex;
     write('  40.00');

     pdr:=40;


     gotoxy(3,7);
     textcolor(12);
     write('Distanta origine-susul ecranului (0 pt. proportie 1:1): ');

     textcolor(15);
     pozo[3]:=wherex;
     write('  0.00');

     ps:=0;


     gotoxy(3,9);
     textcolor(12);
     write('Distanta origine-josul ecranului (0 pt. proportie 1:1): ');

     textcolor(15);
     pozo[4]:=wherex;
     write('  0.00');

     pj:=0;


     gotoxy(3,11);
     textcolor(12);
     write('Numerotarea axei Ox din: ');

     textcolor(15);
     pozo[5]:=wherex;
     write('  4.00');

     nox:=4;


     gotoxy(3,13);
     textcolor(12);
     write('Numerotarea axei Oy din: ');

     textcolor(15);
     pozo[6]:=wherex;
     write('  4.00');

     noy:=4;


     gotoxy(3,15);
     textcolor(12);
     write('Nr. de calcule / pixel (1-100): ');

     textcolor(15);
     pozo[7]:=wherex;
     write('  50');

     numit:=49;



     gotoxy(55,16);
     write('[OK]');
     pozo[8]:=54;

     gotoxy(65,16);
     write('[Anulare]');
     pozo[9]:=64;

     eroare_g:=false;
     while 1=1 do begin
           if not eroare_g then
              che:=upcase(readkey);
           eroare_g:=false;
           if (che='H')or (che='P') or (che='K') or (che='M')  then begin
                 textcolor(9);
                 gotoxy(pozo[oales], 1+2*oales);
                 if oales>7 then
                    gotoxy(wherex, 16);
                 write(' ');

                 if ((che='P') or (che='M')) and (oales<9) then
                    inc(oales)
                 else if ((che='H') or (che='K')) and (oales>1) then
                      dec(oales);

                 gotoxy(pozo[oales], 1+2*oales);
                 if oales>7 then
                    gotoxy(wherex, 16);
                 write(chr(sageatadreapta));
           end;

           if (ord(che)=13) then begin
              gotoxy(3, hi(windmax)-hi(windmin)-2);
              textcolor(15);
              write('Noul numar: ');
              if oales<7 then begin

                 readln(scr);
                 gotoxy(3, hi(windmax)-hi(windmin)-2);
                 clreol;
                 gotoxy(1, wherey+1);
                 clreol;
                 control(scr);
                 case oales of
                      1:begin pst:=abs(eval(scr,40,false,0,0));
                           if pst=0 then pst:=40;
                           gotoxy(pozo[oales]+2, 1+2*oales);
                           clreol;
                           write(pst:1:2);
                           end;
                      2:begin pdr:=abs(eval(scr, 10,false,0,0));
                           if pdr=0 then pdr:=40;
                           gotoxy(pozo[oales]+2,1+2*oales);
                           clreol;
                           write(pdr:1:2);
                           end;
                      3:begin ps:=eval(scr, 10,false,0,0);
                              gotoxy(pozo[oales]+2,1+2*oales);
                              clreol;
                              write(ps:1:2);
                              end;
                      4:begin pj:=eval(scr, 10,false,0,0);
                              gotoxy(pozo[oales]+2,1+2*oales);
                              clreol;
                              write(pj:1:2);
                              end;
                      5:begin nox:=eval(scr, 1,false,0,0);
                           if nox<=0 then nox:=4;
                           gotoxy(pozo[oales]+2,1+2*oales);
                           clreol;
                           write(nox:1:2);
                           end;
                      6:begin noy:=eval(scr, 1,false,0,0);
                           if noy<=0 then noy:=4;
                           gotoxy(pozo[oales]+2,1+2*oales);
                           clreol;
                           write(noy:1:2);
                           end;
                 end;
              end
              else if oales=7 then begin
                   readln(scr);
                   gotoxy(3, hi(windmax)-hi(windmin)-2);
                   clreol;
                   gotoxy(1, wherey+1);
                   clreol;
                   numit:=50;
                   val(scr,numit,cod_g);
                   if numit<=0 then numit:=50 else if numit>100 then
                      numit:=100;
                   gotoxy(pozo[oales]+2,1+2*oales);
                   clreol;
                   write(numit);
                   dec(numit);
              end else if oales=8 then goto 3 else begin
                  window(1,1,lo(wndmax)+1,hi(wndmax)+1);
                  goto 1;
              end;
              che:='P';
              eroare_g:=true;
              gotoxy(pozo[oales]+1,1+2*oales);
           end;

     end;
3:

     gdriver:=detect;
     initgraph(gdriver, gmode, 'd:\bp\bgi');
     if graphresult<>0 then
     begin
          writeln('Eroare la initgraph (graphresult <> 0)');
	  halt;
     end;

     setbkcolor(0);
     setcolor(7);
     settextstyle(smallfont,0,4);
     settextjustify(righttext,toptext);

     unx := 640/(pst+pdr);

     if (ps=0)and(pj=0) then begin
        ps:=barh/1280*(pst+pdr);
        pj:=ps;
     end else if ps=0 then
         ps:=barh/640*(pst+pdr)-pj
     else if pj=0 then
          pj:=barh/640*(pst+pdr)-ps;
     uny := barh/(ps+pj);
     centx := pst*unx;
     centy := ps*uny;
     pozx:=centx;
     pozy:=centy;

     moveto(0,round(centy));
     lineto(640,round(centy));
     moveto(round(centx),0);
     lineto(round(centx),barh);

     ri:=centx;
     rj:=0;
     while ri<=640 do begin     {desenarea grilei, partea cu linii verticale}
           if rj=int(rj) then
              str(rj:2:0, scr)
           else
               str(rj:2:2, scr);
           moveto(round(ri), round(centy));
           if ri<>centx then begin
              setcolor(8);
              line(round(ri),round(centy)-1,round(ri),0);
              line(round(ri),round(centy)+1,round(ri),barh);
           end;
           setcolor(12);
           outtext(scr);
           rj:=rj+nox;
           ri:=ri+unx*nox;
     end;
     ri:=centx-unx*nox;
     rj:=-nox;
     while ri>=0 do begin
           if rj=int(rj) then
              str(rj:2:0, scr)
           else
               str(rj:2:2, scr);
           moveto(round(ri), round(centy));
           if ri<>centx then begin
              setcolor(8);
              line(round(ri),round(centy)-1,round(ri),0);
              line(round(ri),round(centy)+1,round(ri),barh);
           end;
           setcolor(12);
           outtext(scr);
           rj:=rj-nox;
           ri:=ri-unx*nox;

     end;
     ri:=centy;
     rj:=0;
     while ri<=barh do begin    {partea cu orizontale}
           if rj=int(rj) then
              str(-rj:2:0, scr)
           else
               str(-rj:2:2, scr);
           moveto(round(centx), round(ri));
           if ri<>centy then begin
              setcolor(8);
              line(round(centx)-1,round(ri),0,round(ri));
              line(round(centx)+1,round(ri),640,round(ri));
           end;
           setcolor(12);
           outtext(scr);
           rj:=rj+noy;
           ri:=ri+uny*noy;
     end;
     ri:=centy-uny*noy;
     rj:=-noy;
     while ri>=0 do begin
           if rj=int(rj) then
              str(-rj:2:0, scr)
           else
               str(-rj:2:2, scr);
           moveto(round(centx), round(ri));
           if ri<>centx then begin
              setcolor(8);
              line(round(centx)-1,round(ri),0,round(ri));
              line(round(centx)+1,round(ri),640,round(ri));
           end;
           setcolor(12);
           outtext(scr);
           rj:=rj-noy;
           ri:=ri-uny*noy;

     end;

     settextjustify(lefttext,toptext);
     moveto(0,barh+barh2);
     setcolor(6);
     outtext('[X]:iesire; [A],[D]:deplasare; ');
     for k_g:=1 to nfunc do                  {informatii}
     begin
          setcolor(cul[k_g]);
          outtext(func[k_g]);
          outtext('; ');
          if (getx>400)and(gety=barh+barh2)then
             moveto(0,barh+2*barh2);
     end;

     for i_g:=640 downto 0 do
         for j_g:=0 to numit do
             for k_g:=nfunc downto 1 do begin
                 eroare_g:=false;
                 desty:=eval(func[k_g], (i_g - centx + j_g/(numit+1))/unx,false,0,0);
                 if not eroare_g then
                    if (centy - uny*desty <= barh) and (centy - uny*desty >= 0) then
                       putpixel(i_g, round(centy - uny*desty),cul[k_g]);
                 if keypressed then i_g:=0;
             end;   {principala scriere}


     settextjustify(lefttext,toptext);
     setfillstyle(1, 0);
     repeat                             {interfata pornita}
           che:=readkey;
           if (upcase(che)='A') or (upcase(che)='D') then begin
              for i_g:=0 to barh do
                  if (pozx>=0) and (pozx<=640)then
                     if getpixel(round(pozx),i_g)=6 then
                        putpixel(round(pozx),i_g,0);
              if (upcase(che)='A')and(pozx>=-10000) then
                 pozx:=pozx-1
              else if pozx<=10000 then
                  pozx:=pozx+1;

              for i_g:=0 to barh do
                  if (pozx>=0) and (pozx<=640)then
                     if getpixel(round(pozx),i_g)=0 then
                        putpixel(round(pozx),i_g,6);
              str((pozx-centx)/unx:2:4,scr);
              moveto(8,barh);
              bar(0,barh,640,barh+barh2-1);
              setcolor(6);
              outtext(scr);
              outtext('-> ');
              for k_g:=1 to nfunc do begin
                  setcolor(cul[k_g]);
                  eroare_g:=false;
                  str(eval(func[k_g],(pozx-centx)/unx,false,0,0):2:4,scr);
                  if not eroare_g then
                     outtext(scr)
                  else
                     outtext('N');
                  outtext(';   ');
              end
           end
     until upcase(che)='X';

     closegraph;
end;
end
end.