var t1 = @"'GDI11902;MOD;;GD111;MOD;MES\CE_UTES;CFIG;2016-04-01;2016-04-01 14:01:28;3;C;;GDIV3;18432000102;0025136330101;2016-04-01 14:01:28':;;;;:GDIN;CRE;0025136330101;""<INDVD>;1;2016-04-01;0018431990102;    ;A;0025136330101;COTD09099993;         ;            ;1999-09-09;COTE                            ;DANY            ;CD  ;0001;N;                                ;                ;2016-04-01;          ;M;1;1;       ;2;          ;   ;006;F;   ;N;N; ;N;N;N;N;</INDVD>"";""<ADRESSE>;1;2016-04-01;0018431990102;    ;A;12    ;     ;RUE                      ;VILLE                     ;G1C1C1;20230;   ;2222222;N;418;M;</ADRESSE>"";""<ADRCORR>;      ;     ;                         ;                          ;      ;          ;</ADRCORR>"";""<ADRDEC>;2016-04-01;P; ;</ADRDEC>"";""<ADRSCON>; ;          ;             ;    ; ; ;          ;</ADRSCON>"";""<GD-ADMIN>; ;          ;             ;    ; ;                                    ;       ;</GD-ADMIN>"";""<INDADRCOM>;</INDADRCOM>"";<FIN>";
var ttt = Conversions.DecodeDemandeContinuCentral(t1);

string ttt1 = Conversions.ObjetToLigneCsv(ttt.mc_g_part_fixe.mc_g_donn_entt_mesg, true);
string ttt2 = Conversions.ObjetToLigneCsv(ttt.mc_g_part_varb.mcgcomp, true);
string ttt3 = ttt.mc_g_part_varb.mcvcontmesg;
string finalPourCentral = Conversions.ObjetToLigneCsv(new { ttt1, ttt2, ttt3 }, true, ':', '\'');
