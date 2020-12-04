module ycell (cbitin,
    cbitout,
    confclk,
    confclko,
    dempty,
    hempty,
    hempty2,
    lempty,
    rempty,
    reset,
    reseto,
    uempty,
    vempty,
    vempty2,
    din,
    dout,
    lin,
    lout,
    rin,
    rout,
    uin,
    uout);
 input cbitin;
 output cbitout;
 input confclk;
 output confclko;
 input dempty;
 output hempty;
 output hempty2;
 input lempty;
 input rempty;
 input reset;
 output reseto;
 input uempty;
 output vempty;
 output vempty2;
 input [1:0] din;
 output [1:0] dout;
 input [1:0] lin;
 output [1:0] lout;
 input [1:0] rin;
 output [1:0] rout;
 input [1:0] uin;
 output [1:0] uout;

 sky130_fd_sc_hd__or2_2 _079_ (.A(\hfsm.lmatch[1] ),
    .B(\hfsm.lmatch[0] ),
    .X(_041_));
 sky130_fd_sc_hd__nor3_2 _080_ (.A(\hfsm.lin[1] ),
    .B(\hfsm.lin[0] ),
    .C(_041_),
    .Y(_042_));
 sky130_fd_sc_hd__nor2_2 _081_ (.A(\hfsm.nlmempty ),
    .B(_042_),
    .Y(_043_));
 sky130_fd_sc_hd__inv_8 _082_ (.A(\cfg.cnfg[1] ),
    .Y(_044_));
 sky130_fd_sc_hd__inv_8 _083_ (.A(\cfg.cnfg[0] ),
    .Y(_045_));
 sky130_fd_sc_hd__or2_4 _084_ (.A(_044_),
    .B(_045_),
    .X(_046_));
 sky130_fd_sc_hd__buf_6 _085_ (.A(cbitout),
    .X(_047_));
 sky130_fd_sc_hd__or2_2 _086_ (.A(_047_),
    .B(\cfg.cnfg[0] ),
    .X(_048_));
 sky130_fd_sc_hd__nor2_2 _087_ (.A(_044_),
    .B(_047_),
    .Y(_049_));
 sky130_fd_sc_hd__nand2_2 _088_ (.A(_045_),
    .B(_049_),
    .Y(_050_));
 sky130_fd_sc_hd__inv_8 _089_ (.A(_050_),
    .Y(_051_));
 sky130_fd_sc_hd__inv_8 _090_ (.A(_047_),
    .Y(_052_));
 sky130_fd_sc_hd__and3_2 _091_ (.A(_044_),
    .B(_045_),
    .C(_052_),
    .X(_053_));
 sky130_fd_sc_hd__or2_2 _092_ (.A(_051_),
    .B(_053_),
    .X(vempty));
 sky130_fd_sc_hd__or2_2 _093_ (.A(dempty),
    .B(vempty),
    .X(_054_));
 sky130_fd_sc_hd__buf_2 _094_ (.A(_054_),
    .X(_055_));
 sky130_fd_sc_hd__inv_8 _095_ (.A(_055_),
    .Y(_056_));
 sky130_fd_sc_hd__or2_4 _096_ (.A(cbitout),
    .B(_046_),
    .X(_057_));
 sky130_fd_sc_hd__buf_6 _097_ (.A(_057_),
    .X(_058_));
 sky130_fd_sc_hd__inv_8 _098_ (.A(_058_),
    .Y(_059_));
 sky130_fd_sc_hd__a32o_4 _099_ (.A1(\vfsm.lmatch[1] ),
    .A2(\vfsm.lin[1] ),
    .A3(_058_),
    .B1(\vfsm.in[1] ),
    .B2(_059_),
    .X(dout[1]));
 sky130_fd_sc_hd__o22a_4 _100_ (.A1(_056_),
    .A2(dout[1]),
    .B1(din[1]),
    .B2(_055_),
    .X(uout[1]));
 sky130_fd_sc_hd__nand3_2 _101_ (.A(_046_),
    .B(_048_),
    .C(uout[1]),
    .Y(_060_));
 sky130_fd_sc_hd__inv_8 _102_ (.A(uempty),
    .Y(_061_));
 sky130_fd_sc_hd__and2_2 _103_ (.A(uin[0]),
    .B(_061_),
    .X(_062_));
 sky130_fd_sc_hd__or2_2 _104_ (.A(_058_),
    .B(_062_),
    .X(_063_));
 sky130_fd_sc_hd__and2_2 _105_ (.A(\vfsm.lmatch[1] ),
    .B(\vfsm.lin[0] ),
    .X(_064_));
 sky130_fd_sc_hd__o21a_4 _106_ (.A1(\vfsm.lin[0] ),
    .A2(\vfsm.lin[1] ),
    .B1(\vfsm.lmatch[0] ),
    .X(_065_));
 sky130_fd_sc_hd__or3_2 _107_ (.A(_059_),
    .B(_064_),
    .C(_065_),
    .X(_066_));
 sky130_fd_sc_hd__and2_2 _108_ (.A(_063_),
    .B(_066_),
    .X(_067_));
 sky130_fd_sc_hd__buf_1 _109_ (.A(_067_),
    .X(dout[0]));
 sky130_fd_sc_hd__nand2_2 _110_ (.A(_055_),
    .B(dout[0]),
    .Y(_068_));
 sky130_fd_sc_hd__nand2_2 _111_ (.A(din[0]),
    .B(_056_),
    .Y(_069_));
 sky130_fd_sc_hd__nand2_2 _112_ (.A(_068_),
    .B(_069_),
    .Y(uout[0]));
 sky130_fd_sc_hd__or2_2 _113_ (.A(_052_),
    .B(_046_),
    .X(_070_));
 sky130_fd_sc_hd__or2_2 _114_ (.A(\cfg.cnfg[1] ),
    .B(_053_),
    .X(_071_));
 sky130_fd_sc_hd__nand2_2 _115_ (.A(_070_),
    .B(_071_),
    .Y(_072_));
 sky130_fd_sc_hd__nand2_2 _116_ (.A(uout[0]),
    .B(_072_),
    .Y(_073_));
 sky130_fd_sc_hd__and3_2 _117_ (.A(_041_),
    .B(_060_),
    .C(_073_),
    .X(_074_));
 sky130_fd_sc_hd__nor2_2 _118_ (.A(_043_),
    .B(_074_),
    .Y(\hfsm.nlmempty ));
 sky130_fd_sc_hd__nor2_2 _119_ (.A(\vfsm.lin[0] ),
    .B(_062_),
    .Y(_075_));
 sky130_fd_sc_hd__nor2_2 _120_ (.A(\vfsm.clear ),
    .B(_075_),
    .Y(\vfsm.lin[0] ));
 sky130_fd_sc_hd__inv_8 _121_ (.A(\vfsm.nlmempty ),
    .Y(_076_));
 sky130_fd_sc_hd__nor2_2 _122_ (.A(\cfg.cnfg[1] ),
    .B(_045_),
    .Y(_077_));
 sky130_fd_sc_hd__nor2_2 _123_ (.A(_047_),
    .B(_077_),
    .Y(_078_));
 sky130_fd_sc_hd__and3_2 _124_ (.A(_044_),
    .B(\cfg.cnfg[0] ),
    .C(_047_),
    .X(_000_));
 sky130_fd_sc_hd__or2_4 _125_ (.A(_053_),
    .B(_059_),
    .X(hempty));
 sky130_fd_sc_hd__or2_4 _126_ (.A(rempty),
    .B(hempty),
    .X(_001_));
 sky130_fd_sc_hd__buf_6 _127_ (.A(_001_),
    .X(_002_));
 sky130_fd_sc_hd__inv_8 _128_ (.A(_002_),
    .Y(_003_));
 sky130_fd_sc_hd__a32o_4 _129_ (.A1(\hfsm.lmatch[1] ),
    .A2(\hfsm.lin[1] ),
    .A3(_050_),
    .B1(\hfsm.in[1] ),
    .B2(_051_),
    .X(rout[1]));
 sky130_fd_sc_hd__o22a_4 _130_ (.A1(_003_),
    .A2(rout[1]),
    .B1(rin[1]),
    .B2(_002_),
    .X(lout[1]));
 sky130_fd_sc_hd__inv_8 _131_ (.A(lout[1]),
    .Y(_004_));
 sky130_fd_sc_hd__or3_4 _132_ (.A(_078_),
    .B(_000_),
    .C(_004_),
    .X(_005_));
 sky130_fd_sc_hd__nor2_2 _133_ (.A(_076_),
    .B(_005_),
    .Y(_006_));
 sky130_fd_sc_hd__nor2_2 _134_ (.A(\vfsm.lmatch[1] ),
    .B(_006_),
    .Y(_007_));
 sky130_fd_sc_hd__nor2_4 _135_ (.A(\vfsm.clear ),
    .B(_007_),
    .Y(\vfsm.lmatch[1] ));
 sky130_fd_sc_hd__nor2_2 _136_ (.A(\vfsm.in[1] ),
    .B(\vfsm.lin[1] ),
    .Y(_008_));
 sky130_fd_sc_hd__nor2_2 _137_ (.A(\vfsm.clear ),
    .B(_008_),
    .Y(\vfsm.lin[1] ));
 sky130_fd_sc_hd__inv_8 _138_ (.A(lempty),
    .Y(_009_));
 sky130_fd_sc_hd__and2_2 _139_ (.A(lin[0]),
    .B(_009_),
    .X(_010_));
 sky130_fd_sc_hd__or2_2 _140_ (.A(_050_),
    .B(_010_),
    .X(_011_));
 sky130_fd_sc_hd__and2_2 _141_ (.A(\hfsm.lmatch[1] ),
    .B(\hfsm.lin[0] ),
    .X(_012_));
 sky130_fd_sc_hd__o21a_4 _142_ (.A1(\hfsm.lin[1] ),
    .A2(\hfsm.lin[0] ),
    .B1(\hfsm.lmatch[0] ),
    .X(_013_));
 sky130_fd_sc_hd__or3_2 _143_ (.A(_051_),
    .B(_012_),
    .C(_013_),
    .X(_014_));
 sky130_fd_sc_hd__and2_2 _144_ (.A(_011_),
    .B(_014_),
    .X(_015_));
 sky130_fd_sc_hd__buf_1 _145_ (.A(_015_),
    .X(rout[0]));
 sky130_fd_sc_hd__nand2_2 _146_ (.A(_002_),
    .B(rout[0]),
    .Y(_016_));
 sky130_fd_sc_hd__nand2_2 _147_ (.A(rin[0]),
    .B(_003_),
    .Y(_017_));
 sky130_fd_sc_hd__nor2_2 _148_ (.A(\cfg.cnfg[1] ),
    .B(\cfg.cnfg[0] ),
    .Y(_018_));
 sky130_fd_sc_hd__a211o_4 _149_ (.A1(_016_),
    .A2(_017_),
    .B1(_049_),
    .C1(_018_),
    .X(_019_));
 sky130_fd_sc_hd__nor2_2 _150_ (.A(_076_),
    .B(_019_),
    .Y(_020_));
 sky130_fd_sc_hd__nor2_2 _151_ (.A(\vfsm.lmatch[0] ),
    .B(_020_),
    .Y(_021_));
 sky130_fd_sc_hd__nor2_2 _152_ (.A(\vfsm.clear ),
    .B(_021_),
    .Y(\vfsm.lmatch[0] ));
 sky130_fd_sc_hd__inv_8 _153_ (.A(\hfsm.nlmempty ),
    .Y(_022_));
 sky130_fd_sc_hd__nor2_2 _154_ (.A(_022_),
    .B(_073_),
    .Y(_023_));
 sky130_fd_sc_hd__nor2_2 _155_ (.A(\hfsm.lmatch[0] ),
    .B(_023_),
    .Y(_024_));
 sky130_fd_sc_hd__nor2_2 _156_ (.A(\hfsm.clear ),
    .B(_024_),
    .Y(\hfsm.lmatch[0] ));
 sky130_fd_sc_hd__and2_2 _157_ (.A(_061_),
    .B(uin[1]),
    .X(_025_));
 sky130_fd_sc_hd__nor3_2 _158_ (.A(_061_),
    .B(uout[1]),
    .C(uout[0]),
    .Y(_026_));
 sky130_fd_sc_hd__or2_2 _159_ (.A(_025_),
    .B(_026_),
    .X(\vfsm.in[1] ));
 sky130_fd_sc_hd__nor2_2 _160_ (.A(_022_),
    .B(_060_),
    .Y(_027_));
 sky130_fd_sc_hd__nor2_2 _161_ (.A(\hfsm.lmatch[1] ),
    .B(_027_),
    .Y(_028_));
 sky130_fd_sc_hd__nor2_2 _162_ (.A(\hfsm.clear ),
    .B(_028_),
    .Y(\hfsm.lmatch[1] ));
 sky130_fd_sc_hd__nor2_2 _163_ (.A(\hfsm.in[1] ),
    .B(\hfsm.lin[1] ),
    .Y(_029_));
 sky130_fd_sc_hd__nor2_2 _164_ (.A(\hfsm.clear ),
    .B(_029_),
    .Y(\hfsm.lin[1] ));
 sky130_fd_sc_hd__nand2_2 _165_ (.A(_009_),
    .B(lin[1]),
    .Y(_030_));
 sky130_fd_sc_hd__nand2_2 _166_ (.A(_016_),
    .B(_017_),
    .Y(lout[0]));
 sky130_fd_sc_hd__or3_4 _167_ (.A(_009_),
    .B(lout[1]),
    .C(lout[0]),
    .X(_031_));
 sky130_fd_sc_hd__nand2_2 _168_ (.A(_030_),
    .B(_031_),
    .Y(\hfsm.in[1] ));
 sky130_fd_sc_hd__nor2_2 _169_ (.A(\hfsm.lin[0] ),
    .B(_010_),
    .Y(_032_));
 sky130_fd_sc_hd__nor2_2 _170_ (.A(\hfsm.clear ),
    .B(_032_),
    .Y(\hfsm.lin[0] ));
 sky130_fd_sc_hd__nor2_2 _171_ (.A(\vfsm.lin[0] ),
    .B(\vfsm.lin[1] ),
    .Y(_033_));
 sky130_fd_sc_hd__nor4_2 _172_ (.A(\vfsm.in[1] ),
    .B(\vfsm.nlmempty ),
    .C(_062_),
    .D(_033_),
    .Y(_034_));
 sky130_fd_sc_hd__a211o_4 _173_ (.A1(_052_),
    .A2(_045_),
    .B1(reset),
    .C1(_034_),
    .X(\vfsm.clear ));
 sky130_fd_sc_hd__or2_2 _174_ (.A(\vfsm.lmatch[1] ),
    .B(\vfsm.lmatch[0] ),
    .X(_035_));
 sky130_fd_sc_hd__nor3_2 _175_ (.A(\vfsm.lin[0] ),
    .B(\vfsm.lin[1] ),
    .C(_035_),
    .Y(_036_));
 sky130_fd_sc_hd__nor2_2 _176_ (.A(\vfsm.nlmempty ),
    .B(_036_),
    .Y(_037_));
 sky130_fd_sc_hd__and3_4 _177_ (.A(_005_),
    .B(_035_),
    .C(_019_),
    .X(_038_));
 sky130_fd_sc_hd__nor2_4 _178_ (.A(_037_),
    .B(_038_),
    .Y(\vfsm.nlmempty ));
 sky130_fd_sc_hd__nor2_2 _179_ (.A(\hfsm.lin[1] ),
    .B(\hfsm.lin[0] ),
    .Y(_039_));
 sky130_fd_sc_hd__nor4_2 _180_ (.A(\hfsm.in[1] ),
    .B(\hfsm.nlmempty ),
    .C(_039_),
    .D(_010_),
    .Y(_040_));
 sky130_fd_sc_hd__or3_2 _181_ (.A(reset),
    .B(hempty),
    .C(_040_),
    .X(\hfsm.clear ));
 sky130_fd_sc_hd__buf_2 _182_ (.A(confclk),
    .X(confclko));
 sky130_fd_sc_hd__buf_2 _183_ (.A(hempty),
    .X(hempty2));
 sky130_fd_sc_hd__buf_2 _184_ (.A(reset),
    .X(reseto));
 sky130_fd_sc_hd__buf_2 _185_ (.A(vempty),
    .X(vempty2));
 sky130_fd_sc_hd__dfxtp_4 _186_ (.D(cbitin),
    .Q(\cfg.cnfg[0] ),
    .CLK(confclk));
 sky130_fd_sc_hd__dfxtp_4 _187_ (.D(\cfg.cnfg[0] ),
    .Q(\cfg.cnfg[1] ),
    .CLK(confclk));
 sky130_fd_sc_hd__dfxtp_4 _188_ (.D(\cfg.cnfg[1] ),
    .Q(cbitout),
    .CLK(confclk));
 sky130_fd_sc_hd__decap_3 PHY_0 ();
 sky130_fd_sc_hd__decap_3 PHY_1 ();
 sky130_fd_sc_hd__decap_3 PHY_2 ();
 sky130_fd_sc_hd__decap_3 PHY_3 ();
 sky130_fd_sc_hd__decap_3 PHY_4 ();
 sky130_fd_sc_hd__decap_3 PHY_5 ();
 sky130_fd_sc_hd__decap_3 PHY_6 ();
 sky130_fd_sc_hd__decap_3 PHY_7 ();
 sky130_fd_sc_hd__decap_3 PHY_8 ();
 sky130_fd_sc_hd__decap_3 PHY_9 ();
 sky130_fd_sc_hd__decap_3 PHY_10 ();
 sky130_fd_sc_hd__decap_3 PHY_11 ();
 sky130_fd_sc_hd__decap_3 PHY_12 ();
 sky130_fd_sc_hd__decap_3 PHY_13 ();
 sky130_fd_sc_hd__decap_3 PHY_14 ();
 sky130_fd_sc_hd__decap_3 PHY_15 ();
 sky130_fd_sc_hd__decap_3 PHY_16 ();
 sky130_fd_sc_hd__decap_3 PHY_17 ();
 sky130_fd_sc_hd__decap_3 PHY_18 ();
 sky130_fd_sc_hd__decap_3 PHY_19 ();
 sky130_fd_sc_hd__decap_3 PHY_20 ();
 sky130_fd_sc_hd__decap_3 PHY_21 ();
 sky130_fd_sc_hd__decap_3 PHY_22 ();
 sky130_fd_sc_hd__decap_3 PHY_23 ();
 sky130_fd_sc_hd__decap_3 PHY_24 ();
 sky130_fd_sc_hd__decap_3 PHY_25 ();
 sky130_fd_sc_hd__decap_3 PHY_26 ();
 sky130_fd_sc_hd__decap_3 PHY_27 ();
 sky130_fd_sc_hd__decap_3 PHY_28 ();
 sky130_fd_sc_hd__decap_3 PHY_29 ();
 sky130_fd_sc_hd__decap_3 PHY_30 ();
 sky130_fd_sc_hd__decap_3 PHY_31 ();
 sky130_fd_sc_hd__decap_3 PHY_32 ();
 sky130_fd_sc_hd__decap_3 PHY_33 ();
 sky130_fd_sc_hd__decap_3 PHY_34 ();
 sky130_fd_sc_hd__decap_3 PHY_35 ();
 sky130_fd_sc_hd__decap_3 PHY_36 ();
 sky130_fd_sc_hd__decap_3 PHY_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_61 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_65 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_67 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_68 ();
endmodule
