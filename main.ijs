require 'gles'
coinsert 'jgl2 jgles'

combp=: dyad define
'a b c d'=. y['f g h'=. x
(a,f,'(',b,g,c,')',h,d),('((',a,f,b,')',g,c,')',h,d),('(',a,f,b,g,c,')',h,d),:'(',a,f,b,')',g,c,h,d
)

ops=: > , { 3#<'+-*%'
perms=: [: ":"0 [: ~. i.@!@# A. ]
build=: 1 : '(#~ 24 = ".) @: u'

math24=: monad define NB. prefer expressions without parens & fallback if needed
assert. 4 = # y
es=. ([: ,/ ops ([: , (' ',[) ,. ])"1 2/ perms) build y
if. 0 = #es do. es =. ([: ,/ [: ,/ ops combp"1 2/ perms) build y end.
es -."1 ' '
)

check_24=: dyad define
try. assert. -. y -: ''
     evalok=. 24=".y
     numsok=. (/:~x)-:/:~".' '(I.-.y e.'0123456789')}y
     evalok *. numsok return.
catchd. 0 return. end.
)

game_form=: noun define
pc math24 closeok; pn "math-J"; minwh 500 500;
bin h;
  bin v;
    cc win isidraw; set win wh 256 256;
    bin h;
      cc sub edit center; set sub wh 180 25;
      cc new button; cn "new"; set new wh 50 30;
    bin z;
  bin z;
bin z; pshow; psel math24; ptop;
)

math24_close=: monad define
wd'psel math24;pclose;'
)

NB. feed values into global variables. reset edit area.
new_game=: monad define
echo]NUMS=: /:~ 1 + ? 4 $ 13
SOLS=: math24 NUMS
SOLVED=: 0
wd'set sub text ""'
render_game''
)

render_game=: monad define
wd'psel math24'
glclear]glsel 'win'
'a b c d'=. NUMS
'w h'=. glqwh''

NB. rather depp blue: 0 32 166
glfill 255 255 189 255
glfont '"lucida console" 30'
gltextxy 60 100
gltext ": NUMS
glpaint''
)

NB. pressing go! starts a new game. it also submits a solution. if
NB. there are no solutions, the submission area must be empty, in
NB. which case a new card is delt.
check_answer=: monad define
wd'psel math24'
expr=. wd'get sub text'
if. NUMS check_24 expr do.
  echo 'solved!'
  echo expr,' = 24'
  echo 'other solutions:'
  echo SOLS
  SOLVED=: 1
elseif. 0=(#expr)+#SOLS do.
  echo 'indeed, no solutions!'
  SOLVED=: 1
else.
  echo 'wrong!'
  SOLVED=: 0
end.
)

math24_sub_button=: check_answer
math24_new_button=: new_game

mush=: verb define
if. IFQT do.
  wd game_form[math24_close^:(wdisparent'math24')''
  new_game''
else. echo 'run through JQT' end.
)

mush''