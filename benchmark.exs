table = """
F   day                                  weather          temperature  duration || activity
1   Monday,Tuesday,Wednesday,Thursday    rainy            23           1        || read
2   Monday,Tuesday,Wednesday,Thursday    -                34           2        || read,walk
3   Friday                               sunny            45           1        || soccer
4   Friday                               -                10           10       || swim
5   Saturday                             -                2            3        || "watch movie",games
6   Sunday                               -                32           5        || null
7   Monday                               cloudy           28           2        || work
8   Tuesday                              rainy            22           1        || read
9   Wednesday                            -                33           4        || hike
10  Thursday                             -                29           2        || "play guitar"
11  Friday                               sunny            44           1        || soccer
12  Saturday                             -                5            4        || "watch movie",games
13  Sunday                               -                31           3        || "baking,relax"
14  Monday                               rainy            24           2        || work
15  Tuesday                              -                35           1        || read,walk
16  Wednesday                            cloudy           27           3        || hike
17  Thursday                             -                30           2        || "play guitar"
18  Friday                               sunny            46           1        || soccer
19  Saturday                             -                7            5        || "watch movie",games
20  Sunday                               -                30           4        || "baking,relax"
21  Monday                               rainy            23           1        || read
22  Tuesday                              -                34           2        || read,walk
23  Wednesday                            sunny            45           1        || soccer
24  Thursday                             -                10           10       || swim
25  Friday                               -                2            3        || "watch movie",games
26  Saturday                             -                32           5        || null
27  Sunday                               cloudy           28           2        || work
28  Monday                               rainy            22           1        || read
29  Tuesday                              -                33           4        || hike
30  Wednesday                            -                29           2        || "play guitar"
31  Thursday                             sunny            44           1        || soccer
32  Friday                               -                5            4        || "watch movie",games
33  Saturday                             -                31           3        || "baking,relax"
34  Sunday                               rainy            24           2        || work
35  Monday                               -                35           1        || read,walk
36  Tuesday                              cloudy           27           3        || hike
37  Wednesday                            -                30           2        || "play guitar"
38  Thursday                             sunny            46           1        || soccer
39  Saturday                             -                7            5        || "watch movie",games
40  Sunday                               -                30           4        || "baking,relax"
41  Monday                               rainy            23           1        || read
42  Tuesday                              -                34           2        || read,walk
43  Wednesday                            sunny            45           1        || soccer
44  Thursday                             -                10           10       || swim
45  Friday                               -                2            3        || "watch movie",games
46  Saturday                             -                32           5        || null
47  Sunday                               cloudy           28           2        || work
48  Monday                               rainy            22           1        || read
49  Tuesday                              -                33           4        || hike
50  Wednesday                            -                29           2        || "play guitar"
51  Thursday                             sunny            44           1        || soccer
52  Friday                               -                5            4        || "watch movie",games
53  Saturday                             -                31           3        || "baking,relax"
54  Sunday                               rainy            24           2        || work
55  Monday                               -                35           1        || read,walk
56  Tuesday                              cloudy           27           3        || hike
57  Wednesday                            -                30           2        || "play guitar"
58  Thursday                             sunny            46           1        || soccer
59  Saturday                             -                7            5        || "watch movie",games
60  Sunday                               -                30           4        || "baking,relax"
61  Monday                               rainy            23           1        || read
62  Tuesday                              -                34           2        || read,walk
63  Wednesday                            sunny            45           1        || soccer
64  Thursday                             -                10           10       || swim
65  Friday                               -                2            3        || "watch movie",games
66  Saturday                             -                32           5        || null
67  Sunday                               cloudy           28           2        || work
68  Monday                               rainy            22           1        || read
69  Tuesday                              -                33           4        || hike
70  Wednesday                            -                29           2        || "play guitar"
71  Thursday                             sunny            44           1        || soccer
72  Friday                               -                5            4        || "watch movie",games
73  Saturday                             -                31           3        || "baking,relax"
74  Sunday                               rainy            24           2        || work
75  Monday                               -                35           1        || read,walk
76  Tuesday                              cloudy           27           3        || hike
77  Wednesday                            -                30           2        || "play guitar"
78  Thursday                             sunny            46           1        || soccer
79  Saturday                             -                7            5        || "watch movie",games
80  Sunday                               -                30           4        || "baking,relax"
81  Monday                               rainy            23           1        || read
82  Tuesday                              -                34           2        || read,walk
83  Wednesday                            sunny            45           1        || soccer
84  Thursday                             -                10           10       || swim
85  Friday                               -                2            3        || "watch movie",games
86  Saturday                             -                32           5        || null
87  Sunday                               cloudy           28           2        || work
88  Monday                               rainy            22           1        || read
89  Tuesday                              -                33           4        || hike
90  Wednesday                            -                29           2        || "play guitar"
91  Thursday                             sunny            44           1        || soccer
92  Friday                               -                5            4        || "watch movie",games
93  Saturday                             -                31           3        || "baking,relax"
94  Sunday                               rainy            24           2        || work
95  Monday                               -                35           1        || read,walk
96  Tuesday                              cloudy           27           3        || hike
97  Wednesday                            -                30           2        || "play guitar"
98  Thursday                             sunny            46           1        || soccer
99  Saturday                             -                7            5        || "watch movie",games
100 Sunday                               -                30           4        || "baking,relax"
101 Monday                               rainy            23           1        || read
102 Tuesday                              -                34           2        || read,walk
103 Wednesday                            sunny            45           1        || soccer
104 Thursday                             -                10           10       || swim
105 Friday                               -                2            3        || "watch movie",games
106 Saturday                             -                32           5        || null
107 Sunday                               cloudy           28           2        || work
108 Monday                               rainy            22           1        || read
109 Tuesday                              -                33           4        || hike
110 Wednesday                            -                29           2        || "play guitar"
111 Thursday                             sunny            44           1        || soccer
112 Friday                               -                5            4        || "watch movie",games
113 Saturday                             -                31           3        || "baking,relax"
114 Sunday                               rainy            24           2        || work
115 Monday                               -                35           1        || read,walk
116 Tuesday                              cloudy           27           3        || hike
117 Wednesday                            -                30           2        || "play guitar"
118 Thursday                             sunny            46           1        || soccer
119 Saturday                             -                7            5        || "watch movie",games
120 Sunday                               -                30           4        || "baking,relax"
121 Monday                               rainy            23           1        || read
122 Tuesday                              -                34           2        || read,walk
123 Wednesday                            sunny            45           1        || soccer
124 Thursday                             -                10           10       || swim
125 Friday                               -                2            3        || "watch movie",games
126 Saturday                             -                32           5        || null
127 Sunday                               cloudy           28           2        || work
128 Monday                               rainy            22           1        || read
129 Tuesday                              -                33           4        || hike
130 Wednesday                            -                29           2        || "play guitar"
131 Thursday                             sunny            44           1        || soccer
132 Friday                               -                5            4        || "watch movie",games
133 Saturday                             -                31           3        || "baking,relax"
134 Sunday                               rainy            24           2        || work
135 Monday                               -                35           1        || read,walk
136 Tuesday                              cloudy           27           3        || hike
137 Wednesday                            -                30           2        || "play guitar"
138 Thursday                             sunny            46           1        || soccer
139 Saturday                             -                7            5        || "watch movie",games
140 Sunday                               -                30           4        || "baking,relax"
141 Monday                               rainy            23           1        || read
142 Tuesday                              -                34           2        || read,walk
143 Wednesday                            sunny            45           1        || soccer
144 Thursday                             -                10           10       || swim
145 Friday                               -                2            3        || "watch movie",games
146 Saturday                             -                32           5        || null
147 Sunday                               cloudy           28           2        || work
148 Monday                               rainy            22           1        || read
149 Tuesday                              -                33           4        || hike
150 Wednesday                            -                29           2        || "play guitar"
151 Thursday                             sunny            44           1        || soccer
152 Friday                               -                5            4        || "watch movie",games
153 Saturday                             -                31           3        || "baking,relax"
154 Sunday                               rainy            24           2        || work
155 Monday                               -                35           1        || read,walk
156 Tuesday                              cloudy           27           3        || hike
157 Wednesday                            -                30           2        || "play guitar"
158 Thursday                             sunny            46           1        || soccer
159 Saturday                             -                7            5        || "watch movie",games
160 Sunday                               -                30           4        || "baking,relax"
161 Monday                               rainy            23           1        || read
162 Tuesday                              -                34           2        || read,walk
163 Wednesday                            sunny            45           1        || soccer
164 Thursday                             -                10           10       || swim
165 Friday                               -                2            3        || "watch movie",games
166 Saturday                             -                32           5        || null
167 Sunday                               cloudy           28           2        || work
168 Monday                               rainy            22           1        || read
169 Tuesday                              -                33           4        || hike
170 Wednesday                            -                29           2        || "play guitar"
171 Thursday                             sunny            44           1        || soccer
172 Friday                               -                5            4        || "watch movie",games
173 Saturday                             -                31           3        || "baking,relax"
174 Sunday                               rainy            24           2        || work
175 Monday                               -                35           1        || read,walk
176 Tuesday                              cloudy           27           3        || hike
177 Wednesday                            -                30           2        || "play guitar"
178 Thursday                             sunny            46           1        || soccer
179 Saturday                             -                7            5        || "watch movie",games
180 Sunday                               -                30           4        || "baking,relax"
181 Monday                               rainy            23           1        || read
182 Tuesday                              -                34           2        || read,walk
183 Wednesday                            sunny            45           1        || soccer
184 Thursday                             -                10           10       || swim
185 Friday                               -                2            3        || "watch movie",games
186 Saturday                             -                32           5        || null
187 Sunday                               cloudy           28           2        || work
188 Monday                               rainy            22           1        || read
189 Tuesday                              -                33           4        || hike
190 Wednesday                            -                29           2        || "play guitar"
191 Thursday                             sunny            44           1        || soccer
192 Friday                               -                5            4        || "watch movie",games
193 Saturday                             -                31           3        || "baking,relax"
194 Sunday                               rainy            24           2        || work
195 Monday                               -                35           1        || read,walk
196 Tuesday                              cloudy           27           3        || hike
197 Wednesday                            -                30           2        || "play guitar"
198 Thursday                             sunny            46           1        || soccer
199 Saturday                             -                7            5        || "watch movie",games
200 Sunday                               -                30           4        || "baking,relax"
201 Monday                               rainy            23           1        || read
202 Tuesday                              -                34           2        || read,walk
203 Wednesday                            sunny            45           1        || soccer
204 Thursday                             -                10           10       || swim
205 Friday                               -                2            3        || "watch movie",games
206 Saturday                             -                32           5        || null
207 Sunday                               cloudy           28           2        || work
208 Monday                               rainy            22           1        || read
209 Tuesday                              -                33           4        || hike
210 Wednesday                            -                29           2        || "play guitar"
211 Thursday                             sunny            44           1        || soccer
212 Friday                               -                5            4        || "watch movie",games
213 Saturday                             -                31           3        || "baking,relax"
214 Sunday                               rainy            24           2        || work
215 Monday                               -                35           1        || read,walk
216 Tuesday                              cloudy           27           3        || hike
217 Wednesday                            -                30           2        || "play guitar"
218 Thursday                             sunny            46           1        || soccer
219 Saturday                             -                7            5        || "watch movie",games
220 Sunday                               -                30           4        || "baking,relax"
221 Monday                               rainy            23           1        || read
222 Tuesday                              -                34           2        || read,walk
223 Wednesday                            sunny            45           1        || soccer
224 Thursday                             -                10           10       || swim
225 Friday                               -                2            3        || "watch movie",games
226 Saturday                             -                32           5        || null
227 Sunday                               cloudy           28           2        || work
228 Monday                               rainy            22           1        || read
229 Tuesday                              -                33           4        || hike
230 Wednesday                            -                29           2        || "play guitar"
231 Thursday                             sunny            44           1        || soccer
232 Friday                               -                5            4        || "watch movie",games
233 Saturday                             -                31           3        || "baking,relax"
234 Sunday                               rainy            24           2        || work
235 Monday                               -                35           1        || read,walk
236 Tuesday                              cloudy           27           3        || hike
237 Wednesday                            -                30           2        || "play guitar"
238 Thursday                             sunny            46           1        || soccer
239 Saturday                             -                7            5        || "watch movie",games
240 Sunday                               -                30           4        || "baking,relax"
"""


table_medium = """
F   day                                  weather          temperature  duration || activity
1   Monday,Tuesday,Wednesday,Thursday    rainy            23           1        || read
2   Monday,Tuesday,Wednesday,Thursday    -                34           2        || read,walk
3   Friday                               sunny            45           1        || soccer
4   Friday                               -                10           10       || swim
5   Saturday                             -                2            3        || "watch movie",games
6   Sunday                               -                32           5        || null
7   Monday                               cloudy           28           2        || work
8   Tuesday                              rainy            22           1        || read
9   Wednesday                            -                33           4        || hike
10  Thursday                             -                29           2        || "play guitar"
11  Friday                               sunny            44           1        || soccer
12  Saturday                             -                5            4        || "watch movie",games
13  Sunday                               -                31           3        || "baking,relax"
14  Monday                               rainy            24           2        || work
15  Tuesday                              -                35           1        || read,walk
16  Wednesday                            cloudy           27           3        || hike
17  Thursday                             -                30           2        || "play guitar"
18  Friday                               sunny            46           1        || soccer
19  Saturday                             -                7            5        || "watch movie",games
20  Sunday                               -                30           4        || "baking,relax"
21  Monday                               rainy            23           1        || read
22  Tuesday                              -                34           2        || read,walk
23  Wednesday                            sunny            45           1        || soccer
24  Thursday                             -                10           10       || swim
25  Friday                               -                2            3        || "watch movie",games
26  Saturday                             -                32           5        || null
27  Sunday                               cloudy           28           2        || work
28  Monday                               rainy            22           1        || read
29  Tuesday                              -                33           4        || hike
30  Wednesday                            -                29           2        || "play guitar"
31  Thursday                             sunny            44           1        || soccer
32  Friday                               -                5            4        || "watch movie",games
33  Saturday                             -                31           3        || "baking,relax"
34  Sunday                               rainy            24           2        || work
35  Monday                               -                35           1        || read,walk
36  Tuesday                              cloudy           27           3        || hike
37  Wednesday                            -                30           2        || "play guitar"
38  Thursday                             sunny            46           1        || soccer
39  Saturday                             -                7            5        || "watch movie",games
40  Sunday                               -                30           4        || "baking,relax"
41  Monday                               rainy            23           1        || read
42  Tuesday                              -                34           2        || read,walk
43  Wednesday                            sunny            45           1        || soccer
44  Thursday                             -                10           10       || swim
45  Friday                               -                2            3        || "watch movie",games
46  Saturday                             -                32           5        || null
47  Sunday                               cloudy           28           2        || work
48  Monday                               rainy            22           1        || read
49  Tuesday                              -                33           4        || hike
50  Wednesday                            -                29           2        || "play guitar"
51  Thursday                             sunny            44           1        || soccer
52  Friday                               -                5            4        || "watch movie",games
53  Saturday                             -                31           3        || "baking,relax"
54  Sunday                               rainy            24           2        || work
55  Monday                               -                35           1        || read,walk
56  Tuesday                              cloudy           27           3        || hike
57  Wednesday                            -                30           2        || "play guitar"
58  Thursday                             sunny            46           1        || soccer
59  Saturday                             -                7            5        || "watch movie",games
60  Sunday                               -                30           4        || "baking,relax"
61  Monday                               rainy            23           1        || read
62  Tuesday                              -                34           2        || read,walk
63  Wednesday                            sunny            45           1        || soccer
64  Thursday                             -                10           10       || swim
65  Friday                               -                2            3        || "watch movie",games
66  Saturday                             -                32           5        || null
67  Sunday                               cloudy           28           2        || work
68  Monday                               rainy            22           1        || read
69  Tuesday                              -                33           4        || hike
70  Wednesday                            -                29           2        || "play guitar"
71  Thursday                             sunny            44           1        || soccer
72  Friday                               -                5            4        || "watch movie",games
73  Saturday                             -                31           3        || "baking,relax"
74  Sunday                               rainy            24           2        || work
75  Monday                               -                35           1        || read,walk
76  Tuesday                              cloudy           27           3        || hike
77  Wednesday                            -                30           2        || "play guitar"
78  Thursday                             sunny            46           1        || soccer
79  Saturday                             -                7            5        || "watch movie",games
80  Sunday                               -                30           4        || "baking,relax"
81  Monday                               rainy            23           1        || read
82  Tuesday                              -                34           2        || read,walk
83  Wednesday                            sunny            45           1        || soccer
84  Thursday                             -                10           10       || swim
85  Friday                               -                2            3        || "watch movie",games
86  Saturday                             -                32           5        || null
87  Sunday                               cloudy           28           2        || work
88  Monday                               rainy            22           1        || read
89  Tuesday                              -                33           4        || hike
90  Wednesday                            -                29           2        || "play guitar"
91  Thursday                             sunny            44           1        || soccer
92  Friday                               -                5            4        || "watch movie",games
93  Saturday                             -                31           3        || "baking,relax"
94  Sunday                               rainy            24           2        || work
95  Monday                               -                35           1        || read,walk
96  Tuesday                              cloudy           27           3        || hike
97  Wednesday                            -                30           2        || "play guitar"
98  Thursday                             sunny            46           1        || soccer
99  Saturday                             -                7            5        || "watch movie",games
100 Sunday                               -                30           4        || "baking,relax"
101 Monday                               rainy            23           1        || read
102 Tuesday                              -                34           2        || read,walk
103 Wednesday                            sunny            45           1        || soccer
104 Thursday                             -                10           10       || swim
105 Friday                               -                2            3        || "watch movie",games
106 Saturday                             -                32           5        || null
107 Sunday                               cloudy           28           2        || work
108 Monday                               rainy            22           1        || read
109 Tuesday                              -                33           4        || hike
110 Wednesday                            -                29           2        || "play guitar"
111 Thursday                             sunny            44           1        || soccer
112 Friday                               -                5            4        || "watch movie",games
113 Saturday                             -                31           3        || "baking,relax"
114 Sunday                               rainy            24           2        || work
115 Monday                               -                35           1        || read,walk
116 Tuesday                              cloudy           27           3        || hike
117 Wednesday                            -                30           2        || "play guitar"
118 Thursday                             sunny            46           1        || soccer
119 Saturday                             -                7            5        || "watch movie",games
120 Sunday                               -                30           4        || "baking,relax"
121 Monday                               rainy            23           1        || read
122 Tuesday                              -                34           2        || read,walk
123 Wednesday                            sunny            45           1        || soccer
124 Thursday                             -                10           10       || swim
125 Friday                               -                2            3        || "watch movie",games
126 Saturday                             -                32           5        || null
127 Sunday                               cloudy           28           2        || work
128 Monday                               rainy            22           1        || read
129 Tuesday                              -                33           4        || hike
130 Wednesday                            -                29           2        || "play guitar"
131 Thursday                             sunny            44           1        || soccer
132 Friday                               -                5            4        || "watch movie",games
133 Saturday                             -                31           3        || "baking,relax"
134 Sunday                               rainy            24           2        || work
135 Monday                               -                35           1        || read,walk
136 Tuesday                              cloudy           27           3        || hike
137 Wednesday                            -                30           2        || "play guitar"
138 Thursday                             sunny            46           1        || soccer
139 Saturday                             -                7            5        || "watch movie",games
140 Sunday                               -                30           4        || "baking,relax"
141 Monday                               rainy            23           1        || read
142 Tuesday                              -                34           2        || read,walk
143 Wednesday                            sunny            45           1        || soccer
144 Thursday                             -                10           10       || swim
145 Friday                               -                2            3        || "watch movie",games
146 Saturday                             -                32           5        || null
147 Sunday                               cloudy           28           2        || work
148 Monday                               rainy            22           1        || read
149 Tuesday                              -                33           4        || hike
150 Wednesday                            -                29           2        || "play guitar"
151 Thursday                             sunny            44           1        || soccer
152 Friday                               -                5            4        || "watch movie",games
153 Saturday                             -                31           3        || "baking,relax"
154 Sunday                               rainy            24           2        || work
155 Monday                               -                35           1        || read,walk
156 Tuesday                              cloudy           27           3        || hike
157 Wednesday                            -                30           2        || "play guitar"
158 Thursday                             sunny            46           1        || soccer
159 Saturday                             -                7            5        || "watch movie",games
160 Sunday                               -                30           4        || "baking,relax"
161 Monday                               rainy            23           1        || read
162 Tuesday                              -                34           2        || read,walk
163 Wednesday                            sunny            45           1        || soccer
164 Thursday                             -                10           10       || swim
165 Friday                               -                2            3        || "watch movie",games
166 Saturday                             -                32           5        || null
167 Sunday                               cloudy           28           2        || work
168 Monday                               rainy            22           1        || read
169 Tuesday                              -                33           4        || hike
170 Wednesday                            -                29           2        || "play guitar"
171 Thursday                             sunny            44           1        || soccer
172 Friday                               -                5            4        || "watch movie",games
173 Saturday                             -                31           3        || "baking,relax"
174 Sunday                               rainy            24           2        || work
175 Monday                               -                35           1        || read,walk
176 Tuesday                              cloudy           27           3        || hike
177 Wednesday                            -                30           2        || "play guitar"
178 Thursday                             sunny            46           1        || soccer
179 Saturday                             -                7            5        || "watch movie",games
180 Sunday                               -                30           4        || "baking,relax"
181 Monday                               rainy            23           1        || read
182 Tuesday                              -                34           2        || read,walk
183 Wednesday                            sunny            45           1        || soccer
184 Thursday                             -                10           10       || swim
185 Friday                               -                2            3        || "watch movie",games
186 Saturday                             -                32           5        || null
187 Sunday                               cloudy           28           2        || work
188 Monday                               rainy            22           1        || read
189 Tuesday                              -                33           4        || hike
190 Wednesday                            -                29           2        || "play guitar"
191 Thursday                             sunny            44           1        || soccer
192 Friday                               -                5            4        || "watch movie",games
193 Saturday                             -                31           3        || "baking,relax"
194 Sunday                               rainy            24           2        || work
195 Monday                               -                35           1        || read,walk
196 Tuesday                              cloudy           27           3        || hike
197 Wednesday                            -                30           2        || "play guitar"
198 Thursday                             sunny            46           1        || soccer
199 Saturday                             -                7            5        || "watch movie",games
200 Sunday                               -                30           4        || "baking,relax"
201 Monday                               rainy            23           1        || read
202 Tuesday                              -                34           2        || read,walk
203 Wednesday                            sunny            45           1        || soccer
204 Thursday                             -                10           10       || swim
205 Friday                               -                2            3        || "watch movie",games
206 Saturday                             -                32           5        || null
207 Sunday                               cloudy           28           2        || work
208 Monday                               rainy            22           1        || read
209 Tuesday                              -                33           4        || hike
210 Wednesday                            -                29           2        || "play guitar"
211 Thursday                             sunny            44           1        || soccer
212 Friday                               -                5            4        || "watch movie",games
213 Saturday                             -                31           3        || "baking,relax"
214 Sunday                               rainy            24           2        || work
215 Monday                               -                35           1        || read,walk
216 Tuesday                              cloudy           27           3        || hike
217 Wednesday                            -                30           2        || "play guitar"
218 Thursday                             sunny            46           1        || soccer
219 Saturday                             -                7            5        || "watch movie",games
220 Sunday                               -                30           4        || "baking,relax"
221 Monday                               rainy            23           1        || read
222 Tuesday                              -                34           2        || read,walk
223 Wednesday                            sunny            45           1        || soccer
224 Thursday                             -                10           10       || swim
225 Friday                               -                2            3        || "watch movie",games
226 Saturday                             -                32           5        || null
227 Sunday                               cloudy           28           2        || work
228 Monday                               rainy            22           1        || read
229 Tuesday                              -                33           4        || hike
230 Wednesday                            -                29           2        || "play guitar"
231 Thursday                             sunny            44           1        || soccer
232 Friday                               -                5            4        || "watch movie",games
233 Saturday                             -                31           3        || "baking,relax"
234 Sunday                               rainy            24           2        || work
235 Monday                               -                35           1        || read,walk
236 Tuesday                              cloudy           27           3        || hike
237 Wednesday                            -                30           2        || "play guitar"
238 Thursday                             sunny            46           1        || soccer
239 Saturday                             -                7            5        || "watch movie",games
240 Sunday                               -                30           4        || "baking,relax"
1   Monday,Tuesday,Wednesday,Thursday    rainy            23           1        || read
2   Monday,Tuesday,Wednesday,Thursday    -                34           2        || read,walk
3   Friday                               sunny            45           1        || soccer
4   Friday                               -                10           10       || swim
5   Saturday                             -                2            3        || "watch movie",games
6   Sunday                               -                32           5        || null
7   Monday                               cloudy           28           2        || work
8   Tuesday                              rainy            22           1        || read
9   Wednesday                            -                33           4        || hike
10  Thursday                             -                29           2        || "play guitar"
11  Friday                               sunny            44           1        || soccer
12  Saturday                             -                5            4        || "watch movie",games
13  Sunday                               -                31           3        || "baking,relax"
14  Monday                               rainy            24           2        || work
15  Tuesday                              -                35           1        || read,walk
16  Wednesday                            cloudy           27           3        || hike
17  Thursday                             -                30           2        || "play guitar"
18  Friday                               sunny            46           1        || soccer
19  Saturday                             -                7            5        || "watch movie",games
20  Sunday                               -                30           4        || "baking,relax"
21  Monday                               rainy            23           1        || read
22  Tuesday                              -                34           2        || read,walk
23  Wednesday                            sunny            45           1        || soccer
24  Thursday                             -                10           10       || swim
25  Friday                               -                2            3        || "watch movie",games
26  Saturday                             -                32           5        || null
27  Sunday                               cloudy           28           2        || work
28  Monday                               rainy            22           1        || read
29  Tuesday                              -                33           4        || hike
30  Wednesday                            -                29           2        || "play guitar"
31  Thursday                             sunny            44           1        || soccer
32  Friday                               -                5            4        || "watch movie",games
33  Saturday                             -                31           3        || "baking,relax"
34  Sunday                               rainy            24           2        || work
35  Monday                               -                35           1        || read,walk
36  Tuesday                              cloudy           27           3        || hike
37  Wednesday                            -                30           2        || "play guitar"
38  Thursday                             sunny            46           1        || soccer
39  Saturday                             -                7            5        || "watch movie",games
40  Sunday                               -                30           4        || "baking,relax"
41  Monday                               rainy            23           1        || read
42  Tuesday                              -                34           2        || read,walk
43  Wednesday                            sunny            45           1        || soccer
44  Thursday                             -                10           10       || swim
45  Friday                               -                2            3        || "watch movie",games
46  Saturday                             -                32           5        || null
47  Sunday                               cloudy           28           2        || work
48  Monday                               rainy            22           1        || read
49  Tuesday                              -                33           4        || hike
50  Wednesday                            -                29           2        || "play guitar"
51  Thursday                             sunny            44           1        || soccer
52  Friday                               -                5            4        || "watch movie",games
53  Saturday                             -                31           3        || "baking,relax"
54  Sunday                               rainy            24           2        || work
55  Monday                               -                35           1        || read,walk
56  Tuesday                              cloudy           27           3        || hike
57  Wednesday                            -                30           2        || "play guitar"
58  Thursday                             sunny            46           1        || soccer
59  Saturday                             -                7            5        || "watch movie",games
60  Sunday                               -                30           4        || "baking,relax"
61  Monday                               rainy            23           1        || read
62  Tuesday                              -                34           2        || read,walk
63  Wednesday                            sunny            45           1        || soccer
64  Thursday                             -                10           10       || swim
65  Friday                               -                2            3        || "watch movie",games
66  Saturday                             -                32           5        || null
67  Sunday                               cloudy           28           2        || work
68  Monday                               rainy            22           1        || read
69  Tuesday                              -                33           4        || hike
70  Wednesday                            -                29           2        || "play guitar"
71  Thursday                             sunny            44           1        || soccer
72  Friday                               -                5            4        || "watch movie",games
73  Saturday                             -                31           3        || "baking,relax"
74  Sunday                               rainy            24           2        || work
75  Monday                               -                35           1        || read,walk
76  Tuesday                              cloudy           27           3        || hike
77  Wednesday                            -                30           2        || "play guitar"
78  Thursday                             sunny            46           1        || soccer
79  Saturday                             -                7            5        || "watch movie",games
80  Sunday                               -                30           4        || "baking,relax"
81  Monday                               rainy            23           1        || read
82  Tuesday                              -                34           2        || read,walk
83  Wednesday                            sunny            45           1        || soccer
84  Thursday                             -                10           10       || swim
85  Friday                               -                2            3        || "watch movie",games
86  Saturday                             -                32           5        || null
87  Sunday                               cloudy           28           2        || work
88  Monday                               rainy            22           1        || read
89  Tuesday                              -                33           4        || hike
90  Wednesday                            -                29           2        || "play guitar"
91  Thursday                             sunny            44           1        || soccer
92  Friday                               -                5            4        || "watch movie",games
93  Saturday                             -                31           3        || "baking,relax"
94  Sunday                               rainy            24           2        || work
95  Monday                               -                35           1        || read,walk
96  Tuesday                              cloudy           27           3        || hike
97  Wednesday                            -                30           2        || "play guitar"
98  Thursday                             sunny            46           1        || soccer
99  Saturday                             -                7            5        || "watch movie",games
100 Sunday                               -                30           4        || "baking,relax"
101 Monday                               rainy            23           1        || read
102 Tuesday                              -                34           2        || read,walk
103 Wednesday                            sunny            45           1        || soccer
104 Thursday                             -                10           10       || swim
105 Friday                               -                2            3        || "watch movie",games
106 Saturday                             -                32           5        || null
107 Sunday                               cloudy           28           2        || work
108 Monday                               rainy            22           1        || read
109 Tuesday                              -                33           4        || hike
110 Wednesday                            -                29           2        || "play guitar"
111 Thursday                             sunny            44           1        || soccer
112 Friday                               -                5            4        || "watch movie",games
113 Saturday                             -                31           3        || "baking,relax"
114 Sunday                               rainy            24           2        || work
115 Monday                               -                35           1        || read,walk
116 Tuesday                              cloudy           27           3        || hike
117 Wednesday                            -                30           2        || "play guitar"
118 Thursday                             sunny            46           1        || soccer
119 Saturday                             -                7            5        || "watch movie",games
120 Sunday                               -                30           4        || "baking,relax"
121 Monday                               rainy            23           1        || read
122 Tuesday                              -                34           2        || read,walk
123 Wednesday                            sunny            45           1        || soccer
124 Thursday                             -                10           10       || swim
125 Friday                               -                2            3        || "watch movie",games
126 Saturday                             -                32           5        || null
127 Sunday                               cloudy           28           2        || work
128 Monday                               rainy            22           1        || read
129 Tuesday                              -                33           4        || hike
130 Wednesday                            -                29           2        || "play guitar"
131 Thursday                             sunny            44           1        || soccer
132 Friday                               -                5            4        || "watch movie",games
133 Saturday                             -                31           3        || "baking,relax"
134 Sunday                               rainy            24           2        || work
135 Monday                               -                35           1        || read,walk
136 Tuesday                              cloudy           27           3        || hike
137 Wednesday                            -                30           2        || "play guitar"
138 Thursday                             sunny            46           1        || soccer
139 Saturday                             -                7            5        || "watch movie",games
140 Sunday                               -                30           4        || "baking,relax"
141 Monday                               rainy            23           1        || read
142 Tuesday                              -                34           2        || read,walk
143 Wednesday                            sunny            45           1        || soccer
144 Thursday                             -                10           10       || swim
145 Friday                               -                2            3        || "watch movie",games
146 Saturday                             -                32           5        || null
147 Sunday                               cloudy           28           2        || work
148 Monday                               rainy            22           1        || read
149 Tuesday                              -                33           4        || hike
150 Wednesday                            -                29           2        || "play guitar"
151 Thursday                             sunny            44           1        || soccer
152 Friday                               -                5            4        || "watch movie",games
153 Saturday                             -                31           3        || "baking,relax"
154 Sunday                               rainy            24           2        || work
155 Monday                               -                35           1        || read,walk
156 Tuesday                              cloudy           27           3        || hike
157 Wednesday                            -                30           2        || "play guitar"
158 Thursday                             sunny            46           1        || soccer
159 Saturday                             -                7            5        || "watch movie",games
160 Sunday                               -                30           4        || "baking,relax"
161 Monday                               rainy            23           1        || read
162 Tuesday                              -                34           2        || read,walk
163 Wednesday                            sunny            45           1        || soccer
164 Thursday                             -                10           10       || swim
165 Friday                               -                2            3        || "watch movie",games
166 Saturday                             -                32           5        || null
167 Sunday                               cloudy           28           2        || work
168 Monday                               rainy            22           1        || read
169 Tuesday                              -                33           4        || hike
170 Wednesday                            -                29           2        || "play guitar"
171 Thursday                             sunny            44           1        || soccer
172 Friday                               -                5            4        || "watch movie",games
173 Saturday                             -                31           3        || "baking,relax"
174 Sunday                               rainy            24           2        || work
175 Monday                               -                35           1        || read,walk
176 Tuesday                              cloudy           27           3        || hike
177 Wednesday                            -                30           2        || "play guitar"
178 Thursday                             sunny            46           1        || soccer
179 Saturday                             -                7            5        || "watch movie",games
180 Sunday                               -                30           4        || "baking,relax"
181 Monday                               rainy            23           1        || read
182 Tuesday                              -                34           2        || read,walk
183 Wednesday                            sunny            45           1        || soccer
184 Thursday                             -                10           10       || swim
185 Friday                               -                2            3        || "watch movie",games
186 Saturday                             -                32           5        || null
187 Sunday                               cloudy           28           2        || work
188 Monday                               rainy            22           1        || read
189 Tuesday                              -                33           4        || hike
190 Wednesday                            -                29           2        || "play guitar"
191 Thursday                             sunny            44           1        || soccer
192 Friday                               -                5            4        || "watch movie",games
193 Saturday                             -                31           3        || "baking,relax"
194 Sunday                               rainy            24           2        || work
195 Monday                               -                35           1        || read,walk
196 Tuesday                              cloudy           27           3        || hike
197 Wednesday                            -                30           2        || "play guitar"
198 Thursday                             sunny            46           1        || soccer
199 Saturday                             -                7            5        || "watch movie",games
200 Sunday                               -                30           4        || "baking,relax"
201 Monday                               rainy            23           1        || read
202 Tuesday                              -                34           2        || read,walk
203 Wednesday                            sunny            45           1        || soccer
204 Thursday                             -                10           10       || swim
205 Friday                               -                2            3        || "watch movie",games
206 Saturday                             -                32           5        || null
207 Sunday                               cloudy           28           2        || work
208 Monday                               rainy            22           1        || read
209 Tuesday                              -                33           4        || hike
210 Wednesday                            -                29           2        || "play guitar"
211 Thursday                             sunny            44           1        || soccer
212 Friday                               -                5            4        || "watch movie",games
213 Saturday                             -                31           3        || "baking,relax"
214 Sunday                               rainy            24           2        || work
215 Monday                               -                35           1        || read,walk
216 Tuesday                              cloudy           27           3        || hike
217 Wednesday                            -                30           2        || "play guitar"
218 Thursday                             sunny            46           1        || soccer
219 Saturday                             -                7            5        || "watch movie",games
220 Sunday                               -                30           4        || "baking,relax"
221 Monday                               rainy            23           1        || read
222 Tuesday                              -                34           2        || read,walk
223 Wednesday                            sunny            45           1        || soccer
224 Thursday                             -                10           10       || swim
225 Friday                               -                2            3        || "watch movie",games
226 Saturday                             -                32           5        || null
227 Sunday                               cloudy           28           2        || work
228 Monday                               rainy            22           1        || read
229 Tuesday                              -                33           4        || hike
230 Wednesday                            -                29           2        || "play guitar"
231 Thursday                             sunny            44           1        || soccer
232 Friday                               -                5            4        || "watch movie",games
233 Saturday                             -                31           3        || "baking,relax"
234 Sunday                               rainy            24           2        || work
235 Monday                               -                35           1        || read,walk
236 Tuesday                              cloudy           27           3        || hike
237 Wednesday                            -                30           2        || "play guitar"
238 Thursday                             sunny            46           1        || soccer
239 Saturday                             -                7            5        || "watch movie",games
240 Sunday                               -                30           4        || "baking,relax"
1   Monday,Tuesday,Wednesday,Thursday    rainy            23           1        || read
2   Monday,Tuesday,Wednesday,Thursday    -                34           2        || read,walk
3   Friday                               sunny            45           1        || soccer
4   Friday                               -                10           10       || swim
5   Saturday                             -                2            3        || "watch movie",games
6   Sunday                               -                32           5        || null
7   Monday                               cloudy           28           2        || work
8   Tuesday                              rainy            22           1        || read
9   Wednesday                            -                33           4        || hike
10  Thursday                             -                29           2        || "play guitar"
11  Friday                               sunny            44           1        || soccer
12  Saturday                             -                5            4        || "watch movie",games
13  Sunday                               -                31           3        || "baking,relax"
14  Monday                               rainy            24           2        || work
15  Tuesday                              -                35           1        || read,walk
16  Wednesday                            cloudy           27           3        || hike
17  Thursday                             -                30           2        || "play guitar"
18  Friday                               sunny            46           1        || soccer
19  Saturday                             -                7            5        || "watch movie",games
20  Sunday                               -                30           4        || "baking,relax"
21  Monday                               rainy            23           1        || read
22  Tuesday                              -                34           2        || read,walk
23  Wednesday                            sunny            45           1        || soccer
24  Thursday                             -                10           10       || swim
25  Friday                               -                2            3        || "watch movie",games
26  Saturday                             -                32           5        || null
27  Sunday                               cloudy           28           2        || work
28  Monday                               rainy            22           1        || read
29  Tuesday                              -                33           4        || hike
30  Wednesday                            -                29           2        || "play guitar"
31  Thursday                             sunny            44           1        || soccer
32  Friday                               -                5            4        || "watch movie",games
33  Saturday                             -                31           3        || "baking,relax"
34  Sunday                               rainy            24           2        || work
35  Monday                               -                35           1        || read,walk
36  Tuesday                              cloudy           27           3        || hike
37  Wednesday                            -                30           2        || "play guitar"
38  Thursday                             sunny            46           1        || soccer
39  Saturday                             -                7            5        || "watch movie",games
40  Sunday                               -                30           4        || "baking,relax"
41  Monday                               rainy            23           1        || read
42  Tuesday                              -                34           2        || read,walk
43  Wednesday                            sunny            45           1        || soccer
44  Thursday                             -                10           10       || swim
45  Friday                               -                2            3        || "watch movie",games
46  Saturday                             -                32           5        || null
47  Sunday                               cloudy           28           2        || work
48  Monday                               rainy            22           1        || read
49  Tuesday                              -                33           4        || hike
50  Wednesday                            -                29           2        || "play guitar"
51  Thursday                             sunny            44           1        || soccer
52  Friday                               -                5            4        || "watch movie",games
53  Saturday                             -                31           3        || "baking,relax"
54  Sunday                               rainy            24           2        || work
55  Monday                               -                35           1        || read,walk
56  Tuesday                              cloudy           27           3        || hike
57  Wednesday                            -                30           2        || "play guitar"
58  Thursday                             sunny            46           1        || soccer
59  Saturday                             -                7            5        || "watch movie",games
60  Sunday                               -                30           4        || "baking,relax"
61  Monday                               rainy            23           1        || read
62  Tuesday                              -                34           2        || read,walk
63  Wednesday                            sunny            45           1        || soccer
64  Thursday                             -                10           10       || swim
65  Friday                               -                2            3        || "watch movie",games
66  Saturday                             -                32           5        || null
67  Sunday                               cloudy           28           2        || work
68  Monday                               rainy            22           1        || read
69  Tuesday                              -                33           4        || hike
70  Wednesday                            -                29           2        || "play guitar"
71  Thursday                             sunny            44           1        || soccer
72  Friday                               -                5            4        || "watch movie",games
73  Saturday                             -                31           3        || "baking,relax"
74  Sunday                               rainy            24           2        || work
75  Monday                               -                35           1        || read,walk
76  Tuesday                              cloudy           27           3        || hike
77  Wednesday                            -                30           2        || "play guitar"
78  Thursday                             sunny            46           1        || soccer
79  Saturday                             -                7            5        || "watch movie",games
80  Sunday                               -                30           4        || "baking,relax"
81  Monday                               rainy            23           1        || read
82  Tuesday                              -                34           2        || read,walk
83  Wednesday                            sunny            45           1        || soccer
84  Thursday                             -                10           10       || swim
85  Friday                               -                2            3        || "watch movie",games
86  Saturday                             -                32           5        || null
87  Sunday                               cloudy           28           2        || work
88  Monday                               rainy            22           1        || read
89  Tuesday                              -                33           4        || hike
90  Wednesday                            -                29           2        || "play guitar"
91  Thursday                             sunny            44           1        || soccer
92  Friday                               -                5            4        || "watch movie",games
93  Saturday                             -                31           3        || "baking,relax"
94  Sunday                               rainy            24           2        || work
95  Monday                               -                35           1        || read,walk
96  Tuesday                              cloudy           27           3        || hike
97  Wednesday                            -                30           2        || "play guitar"
98  Thursday                             sunny            46           1        || soccer
99  Saturday                             -                7            5        || "watch movie",games
100 Sunday                               -                30           4        || "baking,relax"
101 Monday                               rainy            23           1        || read
102 Tuesday                              -                34           2        || read,walk
103 Wednesday                            sunny            45           1        || soccer
104 Thursday                             -                10           10       || swim
105 Friday                               -                2            3        || "watch movie",games
106 Saturday                             -                32           5        || null
107 Sunday                               cloudy           28           2        || work
108 Monday                               rainy            22           1        || read
109 Tuesday                              -                33           4        || hike
110 Wednesday                            -                29           2        || "play guitar"
111 Thursday                             sunny            44           1        || soccer
112 Friday                               -                5            4        || "watch movie",games
113 Saturday                             -                31           3        || "baking,relax"
114 Sunday                               rainy            24           2        || work
115 Monday                               -                35           1        || read,walk
116 Tuesday                              cloudy           27           3        || hike
117 Wednesday                            -                30           2        || "play guitar"
118 Thursday                             sunny            46           1        || soccer
119 Saturday                             -                7            5        || "watch movie",games
120 Sunday                               -                30           4        || "baking,relax"
121 Monday                               rainy            23           1        || read
122 Tuesday                              -                34           2        || read,walk
123 Wednesday                            sunny            45           1        || soccer
124 Thursday                             -                10           10       || swim
125 Friday                               -                2            3        || "watch movie",games
126 Saturday                             -                32           5        || null
127 Sunday                               cloudy           28           2        || work
128 Monday                               rainy            22           1        || read
129 Tuesday                              -                33           4        || hike
130 Wednesday                            -                29           2        || "play guitar"
131 Thursday                             sunny            44           1        || soccer
132 Friday                               -                5            4        || "watch movie",games
133 Saturday                             -                31           3        || "baking,relax"
134 Sunday                               rainy            24           2        || work
135 Monday                               -                35           1        || read,walk
136 Tuesday                              cloudy           27           3        || hike
137 Wednesday                            -                30           2        || "play guitar"
138 Thursday                             sunny            46           1        || soccer
139 Saturday                             -                7            5        || "watch movie",games
140 Sunday                               -                30           4        || "baking,relax"
141 Monday                               rainy            23           1        || read
142 Tuesday                              -                34           2        || read,walk
143 Wednesday                            sunny            45           1        || soccer
144 Thursday                             -                10           10       || swim
145 Friday                               -                2            3        || "watch movie",games
146 Saturday                             -                32           5        || null
147 Sunday                               cloudy           28           2        || work
148 Monday                               rainy            22           1        || read
149 Tuesday                              -                33           4        || hike
150 Wednesday                            -                29           2        || "play guitar"
151 Thursday                             sunny            44           1        || soccer
152 Friday                               -                5            4        || "watch movie",games
153 Saturday                             -                31           3        || "baking,relax"
154 Sunday                               rainy            24           2        || work
155 Monday                               -                35           1        || read,walk
156 Tuesday                              cloudy           27           3        || hike
157 Wednesday                            -                30           2        || "play guitar"
158 Thursday                             sunny            46           1        || soccer
159 Saturday                             -                7            5        || "watch movie",games
160 Sunday                               -                30           4        || "baking,relax"
161 Monday                               rainy            23           1        || read
162 Tuesday                              -                34           2        || read,walk
163 Wednesday                            sunny            45           1        || soccer
164 Thursday                             -                10           10       || swim
165 Friday                               -                2            3        || "watch movie",games
166 Saturday                             -                32           5        || null
167 Sunday                               cloudy           28           2        || work
168 Monday                               rainy            22           1        || read
169 Tuesday                              -                33           4        || hike
170 Wednesday                            -                29           2        || "play guitar"
171 Thursday                             sunny            44           1        || soccer
172 Friday                               -                5            4        || "watch movie",games
173 Saturday                             -                31           3        || "baking,relax"
174 Sunday                               rainy            24           2        || work
175 Monday                               -                35           1        || read,walk
176 Tuesday                              cloudy           27           3        || hike
177 Wednesday                            -                30           2        || "play guitar"
178 Thursday                             sunny            46           1        || soccer
179 Saturday                             -                7            5        || "watch movie",games
180 Sunday                               -                30           4        || "baking,relax"
181 Monday                               rainy            23           1        || read
182 Tuesday                              -                34           2        || read,walk
183 Wednesday                            sunny            45           1        || soccer
184 Thursday                             -                10           10       || swim
185 Friday                               -                2            3        || "watch movie",games
186 Saturday                             -                32           5        || null
187 Sunday                               cloudy           28           2        || work
188 Monday                               rainy            22           1        || read
189 Tuesday                              -                33           4        || hike
190 Wednesday                            -                29           2        || "play guitar"
191 Thursday                             sunny            44           1        || soccer
192 Friday                               -                5            4        || "watch movie",games
193 Saturday                             -                31           3        || "baking,relax"
194 Sunday                               rainy            24           2        || work
195 Monday                               -                35           1        || read,walk
196 Tuesday                              cloudy           27           3        || hike
197 Wednesday                            -                30           2        || "play guitar"
198 Thursday                             sunny            46           1        || soccer
199 Saturday                             -                7            5        || "watch movie",games
200 Sunday                               -                30           4        || "baking,relax"
201 Monday                               rainy            23           1        || read
202 Tuesday                              -                34           2        || read,walk
203 Wednesday                            sunny            45           1        || soccer
204 Thursday                             -                10           10       || swim
205 Friday                               -                2            3        || "watch movie",games
206 Saturday                             -                32           5        || null
207 Sunday                               cloudy           28           2        || work
208 Monday                               rainy            22           1        || read
209 Tuesday                              -                33           4        || hike
210 Wednesday                            -                29           2        || "play guitar"
211 Thursday                             sunny            44           1        || soccer
212 Friday                               -                5            4        || "watch movie",games
213 Saturday                             -                31           3        || "baking,relax"
214 Sunday                               rainy            24           2        || work
215 Monday                               -                35           1        || read,walk
216 Tuesday                              cloudy           27           3        || hike
217 Wednesday                            -                30           2        || "play guitar"
218 Thursday                             sunny            46           1        || soccer
219 Saturday                             -                7            5        || "watch movie",games
220 Sunday                               -                30           4        || "baking,relax"
221 Monday                               rainy            23           1        || read
222 Tuesday                              -                34           2        || read,walk
223 Wednesday                            sunny            45           1        || soccer
224 Thursday                             -                10           10       || swim
225 Friday                               -                2            3        || "watch movie",games
226 Saturday                             -                32           5        || null
227 Sunday                               cloudy           28           2        || work
228 Monday                               rainy            22           1        || read
229 Tuesday                              -                33           4        || hike
230 Wednesday                            -                29           2        || "play guitar"
231 Thursday                             sunny            44           1        || soccer
232 Friday                               -                5            4        || "watch movie",games
233 Saturday                             -                31           3        || "baking,relax"
234 Sunday                               rainy            24           2        || work
235 Monday                               -                35           1        || read,walk
236 Tuesday                              cloudy           27           3        || hike
237 Wednesday                            -                30           2        || "play guitar"
238 Thursday                             sunny            46           1        || soccer
239 Saturday                             -                7            5        || "watch movie",games
240 Sunday                               -                30           4        || "baking,relax"
1   Monday,Tuesday,Wednesday,Thursday    rainy            23           1        || read
2   Monday,Tuesday,Wednesday,Thursday    -                34           2        || read,walk
3   Friday                               sunny            45           1        || soccer
4   Friday                               -                10           10       || swim
5   Saturday                             -                2            3        || "watch movie",games
6   Sunday                               -                32           5        || null
7   Monday                               cloudy           28           2        || work
8   Tuesday                              rainy            22           1        || read
9   Wednesday                            -                33           4        || hike
10  Thursday                             -                29           2        || "play guitar"
11  Friday                               sunny            44           1        || soccer
12  Saturday                             -                5            4        || "watch movie",games
13  Sunday                               -                31           3        || "baking,relax"
14  Monday                               rainy            24           2        || work
15  Tuesday                              -                35           1        || read,walk
16  Wednesday                            cloudy           27           3        || hike
17  Thursday                             -                30           2        || "play guitar"
18  Friday                               sunny            46           1        || soccer
19  Saturday                             -                7            5        || "watch movie",games
20  Sunday                               -                30           4        || "baking,relax"
21  Monday                               rainy            23           1        || read
22  Tuesday                              -                34           2        || read,walk
23  Wednesday                            sunny            45           1        || soccer
24  Thursday                             -                10           10       || swim
25  Friday                               -                2            3        || "watch movie",games
26  Saturday                             -                32           5        || null
27  Sunday                               cloudy           28           2        || work
28  Monday                               rainy            22           1        || read
29  Tuesday                              -                33           4        || hike
30  Wednesday                            -                29           2        || "play guitar"
31  Thursday                             sunny            44           1        || soccer
32  Friday                               -                5            4        || "watch movie",games
33  Saturday                             -                31           3        || "baking,relax"
34  Sunday                               rainy            24           2        || work
35  Monday                               -                35           1        || read,walk
36  Tuesday                              cloudy           27           3        || hike
37  Wednesday                            -                30           2        || "play guitar"
38  Thursday                             sunny            46           1        || soccer
39  Saturday                             -                7            5        || "watch movie",games
40  Sunday                               -                30           4        || "baking,relax"
41  Monday                               rainy            23           1        || read
42  Tuesday                              -                34           2        || read,walk
43  Wednesday                            sunny            45           1        || soccer
44  Thursday                             -                10           10       || swim
45  Friday                               -                2            3        || "watch movie",games
46  Saturday                             -                32           5        || null
47  Sunday                               cloudy           28           2        || work
48  Monday                               rainy            22           1        || read
49  Tuesday                              -                33           4        || hike
50  Wednesday                            -                29           2        || "play guitar"
51  Thursday                             sunny            44           1        || soccer
52  Friday                               -                5            4        || "watch movie",games
53  Saturday                             -                31           3        || "baking,relax"
54  Sunday                               rainy            24           2        || work
55  Monday                               -                35           1        || read,walk
56  Tuesday                              cloudy           27           3        || hike
57  Wednesday                            -                30           2        || "play guitar"
58  Thursday                             sunny            46           1        || soccer
59  Saturday                             -                7            5        || "watch movie",games
60  Sunday                               -                30           4        || "baking,relax"
61  Monday                               rainy            23           1        || read
62  Tuesday                              -                34           2        || read,walk
63  Wednesday                            sunny            45           1        || soccer
64  Thursday                             -                10           10       || swim
65  Friday                               -                2            3        || "watch movie",games
66  Saturday                             -                32           5        || null
67  Sunday                               cloudy           28           2        || work
68  Monday                               rainy            22           1        || read
69  Tuesday                              -                33           4        || hike
70  Wednesday                            -                29           2        || "play guitar"
71  Thursday                             sunny            44           1        || soccer
72  Friday                               -                5            4        || "watch movie",games
73  Saturday                             -                31           3        || "baking,relax"
74  Sunday                               rainy            24           2        || work
75  Monday                               -                35           1        || read,walk
76  Tuesday                              cloudy           27           3        || hike
77  Wednesday                            -                30           2        || "play guitar"
78  Thursday                             sunny            46           1        || soccer
79  Saturday                             -                7            5        || "watch movie",games
80  Sunday                               -                30           4        || "baking,relax"
81  Monday                               rainy            23           1        || read
82  Tuesday                              -                34           2        || read,walk
83  Wednesday                            sunny            45           1        || soccer
84  Thursday                             -                10           10       || swim
85  Friday                               -                2            3        || "watch movie",games
86  Saturday                             -                32           5        || null
87  Sunday                               cloudy           28           2        || work
88  Monday                               rainy            22           1        || read
89  Tuesday                              -                33           4        || hike
90  Wednesday                            -                29           2        || "play guitar"
91  Thursday                             sunny            44           1        || soccer
92  Friday                               -                5            4        || "watch movie",games
93  Saturday                             -                31           3        || "baking,relax"
94  Sunday                               rainy            24           2        || work
95  Monday                               -                35           1        || read,walk
96  Tuesday                              cloudy           27           3        || hike
97  Wednesday                            -                30           2        || "play guitar"
98  Thursday                             sunny            46           1        || soccer
99  Saturday                             -                7            5        || "watch movie",games
100 Sunday                               -                30           4        || "baking,relax"
101 Monday                               rainy            23           1        || read
102 Tuesday                              -                34           2        || read,walk
103 Wednesday                            sunny            45           1        || soccer
104 Thursday                             -                10           10       || swim
105 Friday                               -                2            3        || "watch movie",games
106 Saturday                             -                32           5        || null
107 Sunday                               cloudy           28           2        || work
108 Monday                               rainy            22           1        || read
109 Tuesday                              -                33           4        || hike
110 Wednesday                            -                29           2        || "play guitar"
111 Thursday                             sunny            44           1        || soccer
112 Friday                               -                5            4        || "watch movie",games
113 Saturday                             -                31           3        || "baking,relax"
114 Sunday                               rainy            24           2        || work
115 Monday                               -                35           1        || read,walk
116 Tuesday                              cloudy           27           3        || hike
117 Wednesday                            -                30           2        || "play guitar"
118 Thursday                             sunny            46           1        || soccer
119 Saturday                             -                7            5        || "watch movie",games
120 Sunday                               -                30           4        || "baking,relax"
121 Monday                               rainy            23           1        || read
122 Tuesday                              -                34           2        || read,walk
123 Wednesday                            sunny            45           1        || soccer
124 Thursday                             -                10           10       || swim
125 Friday                               -                2            3        || "watch movie",games
126 Saturday                             -                32           5        || null
127 Sunday                               cloudy           28           2        || work
128 Monday                               rainy            22           1        || read
129 Tuesday                              -                33           4        || hike
130 Wednesday                            -                29           2        || "play guitar"
131 Thursday                             sunny            44           1        || soccer
132 Friday                               -                5            4        || "watch movie",games
133 Saturday                             -                31           3        || "baking,relax"
134 Sunday                               rainy            24           2        || work
135 Monday                               -                35           1        || read,walk
136 Tuesday                              cloudy           27           3        || hike
137 Wednesday                            -                30           2        || "play guitar"
138 Thursday                             sunny            46           1        || soccer
139 Saturday                             -                7            5        || "watch movie",games
140 Sunday                               -                30           4        || "baking,relax"
141 Monday                               rainy            23           1        || read
142 Tuesday                              -                34           2        || read,walk
143 Wednesday                            sunny            45           1        || soccer
144 Thursday                             -                10           10       || swim
145 Friday                               -                2            3        || "watch movie",games
146 Saturday                             -                32           5        || null
147 Sunday                               cloudy           28           2        || work
148 Monday                               rainy            22           1        || read
149 Tuesday                              -                33           4        || hike
150 Wednesday                            -                29           2        || "play guitar"
151 Thursday                             sunny            44           1        || soccer
152 Friday                               -                5            4        || "watch movie",games
153 Saturday                             -                31           3        || "baking,relax"
154 Sunday                               rainy            24           2        || work
155 Monday                               -                35           1        || read,walk
156 Tuesday                              cloudy           27           3        || hike
157 Wednesday                            -                30           2        || "play guitar"
158 Thursday                             sunny            46           1        || soccer
159 Saturday                             -                7            5        || "watch movie",games
160 Sunday                               -                30           4        || "baking,relax"
161 Monday                               rainy            23           1        || read
162 Tuesday                              -                34           2        || read,walk
163 Wednesday                            sunny            45           1        || soccer
164 Thursday                             -                10           10       || swim
165 Friday                               -                2            3        || "watch movie",games
166 Saturday                             -                32           5        || null
167 Sunday                               cloudy           28           2        || work
168 Monday                               rainy            22           1        || read
169 Tuesday                              -                33           4        || hike
170 Wednesday                            -                29           2        || "play guitar"
171 Thursday                             sunny            44           1        || soccer
172 Friday                               -                5            4        || "watch movie",games
173 Saturday                             -                31           3        || "baking,relax"
174 Sunday                               rainy            24           2        || work
175 Monday                               -                35           1        || read,walk
176 Tuesday                              cloudy           27           3        || hike
177 Wednesday                            -                30           2        || "play guitar"
178 Thursday                             sunny            46           1        || soccer
179 Saturday                             -                7            5        || "watch movie",games
180 Sunday                               -                30           4        || "baking,relax"
181 Monday                               rainy            23           1        || read
182 Tuesday                              -                34           2        || read,walk
183 Wednesday                            sunny            45           1        || soccer
184 Thursday                             -                10           10       || swim
185 Friday                               -                2            3        || "watch movie",games
186 Saturday                             -                32           5        || null
187 Sunday                               cloudy           28           2        || work
188 Monday                               rainy            22           1        || read
189 Tuesday                              -                33           4        || hike
190 Wednesday                            -                29           2        || "play guitar"
191 Thursday                             sunny            44           1        || soccer
192 Friday                               -                5            4        || "watch movie",games
193 Saturday                             -                31           3        || "baking,relax"
194 Sunday                               rainy            24           2        || work
195 Monday                               -                35           1        || read,walk
196 Tuesday                              cloudy           27           3        || hike
197 Wednesday                            -                30           2        || "play guitar"
198 Thursday                             sunny            46           1        || soccer
199 Saturday                             -                7            5        || "watch movie",games
200 Sunday                               -                30           4        || "baking,relax"
201 Monday                               rainy            23           1        || read
202 Tuesday                              -                34           2        || read,walk
203 Wednesday                            sunny            45           1        || soccer
204 Thursday                             -                10           10       || swim
205 Friday                               -                2            3        || "watch movie",games
206 Saturday                             -                32           5        || null
207 Sunday                               cloudy           28           2        || work
208 Monday                               rainy            22           1        || read
209 Tuesday                              -                33           4        || hike
210 Wednesday                            -                29           2        || "play guitar"
211 Thursday                             sunny            44           1        || soccer
212 Friday                               -                5            4        || "watch movie",games
213 Saturday                             -                31           3        || "baking,relax"
214 Sunday                               rainy            24           2        || work
215 Monday                               -                35           1        || read,walk
216 Tuesday                              cloudy           27           3        || hike
217 Wednesday                            -                30           2        || "play guitar"
218 Thursday                             sunny            46           1        || soccer
219 Saturday                             -                7            5        || "watch movie",games
220 Sunday                               -                30           4        || "baking,relax"
221 Monday                               rainy            23           1        || read
222 Tuesday                              -                34           2        || read,walk
223 Wednesday                            sunny            45           1        || soccer
224 Thursday                             -                10           10       || swim
225 Friday                               -                2            3        || "watch movie",games
226 Saturday                             -                32           5        || null
227 Sunday                               cloudy           28           2        || work
228 Monday                               rainy            22           1        || read
229 Tuesday                              -                33           4        || hike
230 Wednesday                            -                29           2        || "play guitar"
231 Thursday                             sunny            44           1        || soccer
232 Friday                               -                5            4        || "watch movie",games
233 Saturday                             -                31           3        || "baking,relax"
234 Sunday                               rainy            24           2        || work
235 Monday                               -                35           1        || read,walk
236 Tuesday                              cloudy           27           3        || hike
237 Wednesday                            -                30           2        || "play guitar"
238 Thursday                             sunny            46           1        || soccer
239 Saturday                             -                7            5        || "watch movie",games
240 Sunday                               -                30           4        || "baking,relax"
1   Monday,Tuesday,Wednesday,Thursday    rainy            23           1        || read
2   Monday,Tuesday,Wednesday,Thursday    -                34           2        || read,walk
3   Friday                               sunny            45           1        || soccer
4   Friday                               -                10           10       || swim
5   Saturday                             -                2            3        || "watch movie",games
6   Sunday                               -                32           5        || null
7   Monday                               cloudy           28           2        || work
8   Tuesday                              rainy            22           1        || read
9   Wednesday                            -                33           4        || hike
10  Thursday                             -                29           2        || "play guitar"
11  Friday                               sunny            44           1        || soccer
12  Saturday                             -                5            4        || "watch movie",games
13  Sunday                               -                31           3        || "baking,relax"
14  Monday                               rainy            24           2        || work
15  Tuesday                              -                35           1        || read,walk
16  Wednesday                            cloudy           27           3        || hike
17  Thursday                             -                30           2        || "play guitar"
18  Friday                               sunny            46           1        || soccer
19  Saturday                             -                7            5        || "watch movie",games
20  Sunday                               -                30           4        || "baking,relax"
21  Monday                               rainy            23           1        || read
22  Tuesday                              -                34           2        || read,walk
23  Wednesday                            sunny            45           1        || soccer
24  Thursday                             -                10           10       || swim
25  Friday                               -                2            3        || "watch movie",games
26  Saturday                             -                32           5        || null
27  Sunday                               cloudy           28           2        || work
28  Monday                               rainy            22           1        || read
29  Tuesday                              -                33           4        || hike
30  Wednesday                            -                29           2        || "play guitar"
31  Thursday                             sunny            44           1        || soccer
32  Friday                               -                5            4        || "watch movie",games
33  Saturday                             -                31           3        || "baking,relax"
34  Sunday                               rainy            24           2        || work
35  Monday                               -                35           1        || read,walk
36  Tuesday                              cloudy           27           3        || hike
37  Wednesday                            -                30           2        || "play guitar"
38  Thursday                             sunny            46           1        || soccer
39  Saturday                             -                7            5        || "watch movie",games
40  Sunday                               -                30           4        || "baking,relax"
41  Monday                               rainy            23           1        || read
42  Tuesday                              -                34           2        || read,walk
43  Wednesday                            sunny            45           1        || soccer
44  Thursday                             -                10           10       || swim
45  Friday                               -                2            3        || "watch movie",games
46  Saturday                             -                32           5        || null
47  Sunday                               cloudy           28           2        || work
48  Monday                               rainy            22           1        || read
49  Tuesday                              -                33           4        || hike
50  Wednesday                            -                29           2        || "play guitar"
51  Thursday                             sunny            44           1        || soccer
52  Friday                               -                5            4        || "watch movie",games
53  Saturday                             -                31           3        || "baking,relax"
54  Sunday                               rainy            24           2        || work
55  Monday                               -                35           1        || read,walk
56  Tuesday                              cloudy           27           3        || hike
57  Wednesday                            -                30           2        || "play guitar"
58  Thursday                             sunny            46           1        || soccer
59  Saturday                             -                7            5        || "watch movie",games
60  Sunday                               -                30           4        || "baking,relax"
61  Monday                               rainy            23           1        || read
62  Tuesday                              -                34           2        || read,walk
63  Wednesday                            sunny            45           1        || soccer
64  Thursday                             -                10           10       || swim
65  Friday                               -                2            3        || "watch movie",games
66  Saturday                             -                32           5        || null
67  Sunday                               cloudy           28           2        || work
68  Monday                               rainy            22           1        || read
69  Tuesday                              -                33           4        || hike
70  Wednesday                            -                29           2        || "play guitar"
71  Thursday                             sunny            44           1        || soccer
72  Friday                               -                5            4        || "watch movie",games
73  Saturday                             -                31           3        || "baking,relax"
74  Sunday                               rainy            24           2        || work
75  Monday                               -                35           1        || read,walk
76  Tuesday                              cloudy           27           3        || hike
77  Wednesday                            -                30           2        || "play guitar"
78  Thursday                             sunny            46           1        || soccer
79  Saturday                             -                7            5        || "watch movie",games
80  Sunday                               -                30           4        || "baking,relax"
81  Monday                               rainy            23           1        || read
82  Tuesday                              -                34           2        || read,walk
83  Wednesday                            sunny            45           1        || soccer
84  Thursday                             -                10           10       || swim
85  Friday                               -                2            3        || "watch movie",games
86  Saturday                             -                32           5        || null
87  Sunday                               cloudy           28           2        || work
88  Monday                               rainy            22           1        || read
89  Tuesday                              -                33           4        || hike
90  Wednesday                            -                29           2        || "play guitar"
91  Thursday                             sunny            44           1        || soccer
92  Friday                               -                5            4        || "watch movie",games
93  Saturday                             -                31           3        || "baking,relax"
94  Sunday                               rainy            24           2        || work
95  Monday                               -                35           1        || read,walk
96  Tuesday                              cloudy           27           3        || hike
97  Wednesday                            -                30           2        || "play guitar"
98  Thursday                             sunny            46           1        || soccer
99  Saturday                             -                7            5        || "watch movie",games
100 Sunday                               -                30           4        || "baking,relax"
101 Monday                               rainy            23           1        || read
102 Tuesday                              -                34           2        || read,walk
103 Wednesday                            sunny            45           1        || soccer
104 Thursday                             -                10           10       || swim
105 Friday                               -                2            3        || "watch movie",games
106 Saturday                             -                32           5        || null
107 Sunday                               cloudy           28           2        || work
108 Monday                               rainy            22           1        || read
109 Tuesday                              -                33           4        || hike
110 Wednesday                            -                29           2        || "play guitar"
111 Thursday                             sunny            44           1        || soccer
112 Friday                               -                5            4        || "watch movie",games
113 Saturday                             -                31           3        || "baking,relax"
114 Sunday                               rainy            24           2        || work
115 Monday                               -                35           1        || read,walk
116 Tuesday                              cloudy           27           3        || hike
117 Wednesday                            -                30           2        || "play guitar"
118 Thursday                             sunny            46           1        || soccer
119 Saturday                             -                7            5        || "watch movie",games
120 Sunday                               -                30           4        || "baking,relax"
121 Monday                               rainy            23           1        || read
122 Tuesday                              -                34           2        || read,walk
123 Wednesday                            sunny            45           1        || soccer
124 Thursday                             -                10           10       || swim
125 Friday                               -                2            3        || "watch movie",games
126 Saturday                             -                32           5        || null
127 Sunday                               cloudy           28           2        || work
128 Monday                               rainy            22           1        || read
129 Tuesday                              -                33           4        || hike
130 Wednesday                            -                29           2        || "play guitar"
131 Thursday                             sunny            44           1        || soccer
132 Friday                               -                5            4        || "watch movie",games
133 Saturday                             -                31           3        || "baking,relax"
134 Sunday                               rainy            24           2        || work
135 Monday                               -                35           1        || read,walk
136 Tuesday                              cloudy           27           3        || hike
137 Wednesday                            -                30           2        || "play guitar"
138 Thursday                             sunny            46           1        || soccer
139 Saturday                             -                7            5        || "watch movie",games
140 Sunday                               -                30           4        || "baking,relax"
141 Monday                               rainy            23           1        || read
142 Tuesday                              -                34           2        || read,walk
143 Wednesday                            sunny            45           1        || soccer
144 Thursday                             -                10           10       || swim
145 Friday                               -                2            3        || "watch movie",games
146 Saturday                             -                32           5        || null
147 Sunday                               cloudy           28           2        || work
148 Monday                               rainy            22           1        || read
149 Tuesday                              -                33           4        || hike
150 Wednesday                            -                29           2        || "play guitar"
151 Thursday                             sunny            44           1        || soccer
152 Friday                               -                5            4        || "watch movie",games
153 Saturday                             -                31           3        || "baking,relax"
154 Sunday                               rainy            24           2        || work
155 Monday                               -                35           1        || read,walk
156 Tuesday                              cloudy           27           3        || hike
157 Wednesday                            -                30           2        || "play guitar"
158 Thursday                             sunny            46           1        || soccer
159 Saturday                             -                7            5        || "watch movie",games
160 Sunday                               -                30           4        || "baking,relax"
161 Monday                               rainy            23           1        || read
162 Tuesday                              -                34           2        || read,walk
163 Wednesday                            sunny            45           1        || soccer
164 Thursday                             -                10           10       || swim
165 Friday                               -                2            3        || "watch movie",games
166 Saturday                             -                32           5        || null
167 Sunday                               cloudy           28           2        || work
168 Monday                               rainy            22           1        || read
169 Tuesday                              -                33           4        || hike
170 Wednesday                            -                29           2        || "play guitar"
171 Thursday                             sunny            44           1        || soccer
172 Friday                               -                5            4        || "watch movie",games
173 Saturday                             -                31           3        || "baking,relax"
174 Sunday                               rainy            24           2        || work
175 Monday                               -                35           1        || read,walk
176 Tuesday                              cloudy           27           3        || hike
177 Wednesday                            -                30           2        || "play guitar"
178 Thursday                             sunny            46           1        || soccer
179 Saturday                             -                7            5        || "watch movie",games
180 Sunday                               -                30           4        || "baking,relax"
181 Monday                               rainy            23           1        || read
182 Tuesday                              -                34           2        || read,walk
183 Wednesday                            sunny            45           1        || soccer
184 Thursday                             -                10           10       || swim
185 Friday                               -                2            3        || "watch movie",games
186 Saturday                             -                32           5        || null
187 Sunday                               cloudy           28           2        || work
188 Monday                               rainy            22           1        || read
189 Tuesday                              -                33           4        || hike
190 Wednesday                            -                29           2        || "play guitar"
191 Thursday                             sunny            44           1        || soccer
192 Friday                               -                5            4        || "watch movie",games
193 Saturday                             -                31           3        || "baking,relax"
194 Sunday                               rainy            24           2        || work
195 Monday                               -                35           1        || read,walk
196 Tuesday                              cloudy           27           3        || hike
197 Wednesday                            -                30           2        || "play guitar"
198 Thursday                             sunny            46           1        || soccer
199 Saturday                             -                7            5        || "watch movie",games
200 Sunday                               -                30           4        || "baking,relax"
201 Monday                               rainy            23           1        || read
202 Tuesday                              -                34           2        || read,walk
203 Wednesday                            sunny            45           1        || soccer
204 Thursday                             -                10           10       || swim
205 Friday                               -                2            3        || "watch movie",games
206 Saturday                             -                32           5        || null
207 Sunday                               cloudy           28           2        || work
208 Monday                               rainy            22           1        || read
209 Tuesday                              -                33           4        || hike
210 Wednesday                            -                29           2        || "play guitar"
211 Thursday                             sunny            44           1        || soccer
212 Friday                               -                5            4        || "watch movie",games
213 Saturday                             -                31           3        || "baking,relax"
214 Sunday                               rainy            24           2        || work
215 Monday                               -                35           1        || read,walk
216 Tuesday                              cloudy           27           3        || hike
217 Wednesday                            -                30           2        || "play guitar"
218 Thursday                             sunny            46           1        || soccer
219 Saturday                             -                7            5        || "watch movie",games
220 Sunday                               -                30           4        || "baking,relax"
221 Monday                               rainy            23           1        || read
222 Tuesday                              -                34           2        || read,walk
223 Wednesday                            sunny            45           1        || soccer
224 Thursday                             -                10           10       || swim
225 Friday                               -                2            3        || "watch movie",games
226 Saturday                             -                32           5        || null
227 Sunday                               cloudy           28           2        || work
228 Monday                               rainy            22           1        || read
229 Tuesday                              -                33           4        || hike
230 Wednesday                            -                29           2        || "play guitar"
231 Thursday                             sunny            44           1        || soccer
232 Friday                               -                5            4        || "watch movie",games
233 Saturday                             -                31           3        || "baking,relax"
234 Sunday                               rainy            24           2        || work
235 Monday                               -                35           1        || read,walk
236 Tuesday                              cloudy           27           3        || hike
237 Wednesday                            -                30           2        || "play guitar"
238 Thursday                             sunny            46           1        || soccer
239 Saturday                             -                7            5        || "watch movie",games
240 Sunday                               -                30           4        || "baking,relax"
1   Monday,Tuesday,Wednesday,Thursday    rainy            23           1        || read
2   Monday,Tuesday,Wednesday,Thursday    -                34           2        || read,walk
3   Friday                               sunny            45           1        || soccer
4   Friday                               -                10           10       || swim
5   Saturday                             -                2            3        || "watch movie",games
6   Sunday                               -                32           5        || null
7   Monday                               cloudy           28           2        || work
8   Tuesday                              rainy            22           1        || read
9   Wednesday                            -                33           4        || hike
10  Thursday                             -                29           2        || "play guitar"
11  Friday                               sunny            44           1        || soccer
12  Saturday                             -                5            4        || "watch movie",games
13  Sunday                               -                31           3        || "baking,relax"
14  Monday                               rainy            24           2        || work
15  Tuesday                              -                35           1        || read,walk
16  Wednesday                            cloudy           27           3        || hike
17  Thursday                             -                30           2        || "play guitar"
18  Friday                               sunny            46           1        || soccer
19  Saturday                             -                7            5        || "watch movie",games
20  Sunday                               -                30           4        || "baking,relax"
21  Monday                               rainy            23           1        || read
22  Tuesday                              -                34           2        || read,walk
23  Wednesday                            sunny            45           1        || soccer
24  Thursday                             -                10           10       || swim
25  Friday                               -                2            3        || "watch movie",games
26  Saturday                             -                32           5        || null
27  Sunday                               cloudy           28           2        || work
28  Monday                               rainy            22           1        || read
29  Tuesday                              -                33           4        || hike
30  Wednesday                            -                29           2        || "play guitar"
31  Thursday                             sunny            44           1        || soccer
32  Friday                               -                5            4        || "watch movie",games
33  Saturday                             -                31           3        || "baking,relax"
34  Sunday                               rainy            24           2        || work
35  Monday                               -                35           1        || read,walk
36  Tuesday                              cloudy           27           3        || hike
37  Wednesday                            -                30           2        || "play guitar"
38  Thursday                             sunny            46           1        || soccer
39  Saturday                             -                7            5        || "watch movie",games
40  Sunday                               -                30           4        || "baking,relax"
41  Monday                               rainy            23           1        || read
42  Tuesday                              -                34           2        || read,walk
43  Wednesday                            sunny            45           1        || soccer
44  Thursday                             -                10           10       || swim
45  Friday                               -                2            3        || "watch movie",games
46  Saturday                             -                32           5        || null
47  Sunday                               cloudy           28           2        || work
48  Monday                               rainy            22           1        || read
49  Tuesday                              -                33           4        || hike
50  Wednesday                            -                29           2        || "play guitar"
51  Thursday                             sunny            44           1        || soccer
52  Friday                               -                5            4        || "watch movie",games
53  Saturday                             -                31           3        || "baking,relax"
54  Sunday                               rainy            24           2        || work
55  Monday                               -                35           1        || read,walk
56  Tuesday                              cloudy           27           3        || hike
57  Wednesday                            -                30           2        || "play guitar"
58  Thursday                             sunny            46           1        || soccer
59  Saturday                             -                7            5        || "watch movie",games
60  Sunday                               -                30           4        || "baking,relax"
61  Monday                               rainy            23           1        || read
62  Tuesday                              -                34           2        || read,walk
63  Wednesday                            sunny            45           1        || soccer
64  Thursday                             -                10           10       || swim
65  Friday                               -                2            3        || "watch movie",games
66  Saturday                             -                32           5        || null
67  Sunday                               cloudy           28           2        || work
68  Monday                               rainy            22           1        || read
69  Tuesday                              -                33           4        || hike
70  Wednesday                            -                29           2        || "play guitar"
71  Thursday                             sunny            44           1        || soccer
72  Friday                               -                5            4        || "watch movie",games
73  Saturday                             -                31           3        || "baking,relax"
74  Sunday                               rainy            24           2        || work
75  Monday                               -                35           1        || read,walk
76  Tuesday                              cloudy           27           3        || hike
77  Wednesday                            -                30           2        || "play guitar"
78  Thursday                             sunny            46           1        || soccer
79  Saturday                             -                7            5        || "watch movie",games
80  Sunday                               -                30           4        || "baking,relax"
81  Monday                               rainy            23           1        || read
82  Tuesday                              -                34           2        || read,walk
83  Wednesday                            sunny            45           1        || soccer
84  Thursday                             -                10           10       || swim
85  Friday                               -                2            3        || "watch movie",games
86  Saturday                             -                32           5        || null
87  Sunday                               cloudy           28           2        || work
88  Monday                               rainy            22           1        || read
89  Tuesday                              -                33           4        || hike
90  Wednesday                            -                29           2        || "play guitar"
91  Thursday                             sunny            44           1        || soccer
92  Friday                               -                5            4        || "watch movie",games
93  Saturday                             -                31           3        || "baking,relax"
94  Sunday                               rainy            24           2        || work
95  Monday                               -                35           1        || read,walk
96  Tuesday                              cloudy           27           3        || hike
97  Wednesday                            -                30           2        || "play guitar"
98  Thursday                             sunny            46           1        || soccer
99  Saturday                             -                7            5        || "watch movie",games
100 Sunday                               -                30           4        || "baking,relax"
101 Monday                               rainy            23           1        || read
102 Tuesday                              -                34           2        || read,walk
103 Wednesday                            sunny            45           1        || soccer
104 Thursday                             -                10           10       || swim
105 Friday                               -                2            3        || "watch movie",games
106 Saturday                             -                32           5        || null
107 Sunday                               cloudy           28           2        || work
108 Monday                               rainy            22           1        || read
109 Tuesday                              -                33           4        || hike
110 Wednesday                            -                29           2        || "play guitar"
111 Thursday                             sunny            44           1        || soccer
112 Friday                               -                5            4        || "watch movie",games
113 Saturday                             -                31           3        || "baking,relax"
114 Sunday                               rainy            24           2        || work
115 Monday                               -                35           1        || read,walk
116 Tuesday                              cloudy           27           3        || hike
117 Wednesday                            -                30           2        || "play guitar"
118 Thursday                             sunny            46           1        || soccer
119 Saturday                             -                7            5        || "watch movie",games
120 Sunday                               -                30           4        || "baking,relax"
121 Monday                               rainy            23           1        || read
122 Tuesday                              -                34           2        || read,walk
123 Wednesday                            sunny            45           1        || soccer
124 Thursday                             -                10           10       || swim
125 Friday                               -                2            3        || "watch movie",games
126 Saturday                             -                32           5        || null
127 Sunday                               cloudy           28           2        || work
128 Monday                               rainy            22           1        || read
129 Tuesday                              -                33           4        || hike
130 Wednesday                            -                29           2        || "play guitar"
131 Thursday                             sunny            44           1        || soccer
132 Friday                               -                5            4        || "watch movie",games
133 Saturday                             -                31           3        || "baking,relax"
134 Sunday                               rainy            24           2        || work
135 Monday                               -                35           1        || read,walk
136 Tuesday                              cloudy           27           3        || hike
137 Wednesday                            -                30           2        || "play guitar"
138 Thursday                             sunny            46           1        || soccer
139 Saturday                             -                7            5        || "watch movie",games
140 Sunday                               -                30           4        || "baking,relax"
141 Monday                               rainy            23           1        || read
142 Tuesday                              -                34           2        || read,walk
143 Wednesday                            sunny            45           1        || soccer
144 Thursday                             -                10           10       || swim
145 Friday                               -                2            3        || "watch movie",games
146 Saturday                             -                32           5        || null
147 Sunday                               cloudy           28           2        || work
148 Monday                               rainy            22           1        || read
149 Tuesday                              -                33           4        || hike
150 Wednesday                            -                29           2        || "play guitar"
151 Thursday                             sunny            44           1        || soccer
152 Friday                               -                5            4        || "watch movie",games
153 Saturday                             -                31           3        || "baking,relax"
154 Sunday                               rainy            24           2        || work
155 Monday                               -                35           1        || read,walk
156 Tuesday                              cloudy           27           3        || hike
157 Wednesday                            -                30           2        || "play guitar"
158 Thursday                             sunny            46           1        || soccer
159 Saturday                             -                7            5        || "watch movie",games
160 Sunday                               -                30           4        || "baking,relax"
161 Monday                               rainy            23           1        || read
162 Tuesday                              -                34           2        || read,walk
163 Wednesday                            sunny            45           1        || soccer
164 Thursday                             -                10           10       || swim
165 Friday                               -                2            3        || "watch movie",games
166 Saturday                             -                32           5        || null
167 Sunday                               cloudy           28           2        || work
168 Monday                               rainy            22           1        || read
169 Tuesday                              -                33           4        || hike
170 Wednesday                            -                29           2        || "play guitar"
171 Thursday                             sunny            44           1        || soccer
172 Friday                               -                5            4        || "watch movie",games
173 Saturday                             -                31           3        || "baking,relax"
174 Sunday                               rainy            24           2        || work
175 Monday                               -                35           1        || read,walk
176 Tuesday                              cloudy           27           3        || hike
177 Wednesday                            -                30           2        || "play guitar"
178 Thursday                             sunny            46           1        || soccer
179 Saturday                             -                7            5        || "watch movie",games
180 Sunday                               -                30           4        || "baking,relax"
181 Monday                               rainy            23           1        || read
182 Tuesday                              -                34           2        || read,walk
183 Wednesday                            sunny            45           1        || soccer
184 Thursday                             -                10           10       || swim
185 Friday                               -                2            3        || "watch movie",games
186 Saturday                             -                32           5        || null
187 Sunday                               cloudy           28           2        || work
188 Monday                               rainy            22           1        || read
189 Tuesday                              -                33           4        || hike
190 Wednesday                            -                29           2        || "play guitar"
191 Thursday                             sunny            44           1        || soccer
192 Friday                               -                5            4        || "watch movie",games
193 Saturday                             -                31           3        || "baking,relax"
194 Sunday                               rainy            24           2        || work
195 Monday                               -                35           1        || read,walk
196 Tuesday                              cloudy           27           3        || hike
197 Wednesday                            -                30           2        || "play guitar"
198 Thursday                             sunny            46           1        || soccer
199 Saturday                             -                7            5        || "watch movie",games
200 Sunday                               -                30           4        || "baking,relax"
201 Monday                               rainy            23           1        || read
202 Tuesday                              -                34           2        || read,walk
203 Wednesday                            sunny            45           1        || soccer
204 Thursday                             -                10           10       || swim
205 Friday                               -                2            3        || "watch movie",games
206 Saturday                             -                32           5        || null
207 Sunday                               cloudy           28           2        || work
208 Monday                               rainy            22           1        || read
209 Tuesday                              -                33           4        || hike
210 Wednesday                            -                29           2        || "play guitar"
211 Thursday                             sunny            44           1        || soccer
212 Friday                               -                5            4        || "watch movie",games
213 Saturday                             -                31           3        || "baking,relax"
214 Sunday                               rainy            24           2        || work
215 Monday                               -                35           1        || read,walk
216 Tuesday                              cloudy           27           3        || hike
217 Wednesday                            -                30           2        || "play guitar"
218 Thursday                             sunny            46           1        || soccer
219 Saturday                             -                7            5        || "watch movie",games
220 Sunday                               -                30           4        || "baking,relax"
221 Monday                               rainy            23           1        || read
222 Tuesday                              -                34           2        || read,walk
223 Wednesday                            sunny            45           1        || soccer
224 Thursday                             -                10           10       || swim
225 Friday                               -                2            3        || "watch movie",games
226 Saturday                             -                32           5        || null
227 Sunday                               cloudy           28           2        || work
228 Monday                               rainy            22           1        || read
229 Tuesday                              -                33           4        || hike
230 Wednesday                            -                29           2        || "play guitar"
231 Thursday                             sunny            44           1        || soccer
232 Friday                               -                5            4        || "watch movie",games
233 Saturday                             -                31           3        || "baking,relax"
234 Sunday                               rainy            24           2        || work
235 Monday                               -                35           1        || read,walk
236 Tuesday                              cloudy           27           3        || hike
237 Wednesday                            -                30           2        || "play guitar"
238 Thursday                             sunny            46           1        || soccer
239 Saturday                             -                7            5        || "watch movie",games
240 Sunday                               -                30           4        || "baking,relax"
"""

tablex_240 = Tablex.new(table)

tablex_medium = Tablex.new(table_medium)

Benchee.run(%{
  "rete_medium"    => fn -> Tablex.Decider.Rete.decide(tablex_medium, %{day: "Monday", weather: "rainy", temperature: "-2-3°C", location: "snow park", duration: "3"}) end,
  "naive_medium" => fn -> Tablex.Decider.Rete.decide(tablex_medium, %{day: "Monday", weather: "rainy", temperature: "-2-3°C", location: "snow park", duration: "3"}) end
})

Benchee.run(%{
  "rete_240"    => fn -> Tablex.Decider.Rete.decide(tablex_240, %{day: "Monday", weather: "rainy", temperature: "-2-3°C", location: "snow park", duration: "3"}) end,
  "naive_240" => fn -> Tablex.Decider.Rete.decide(tablex_240, %{day: "Monday", weather: "rainy", temperature: "-2-3°C", location: "snow park", duration: "3"}) end,
})
