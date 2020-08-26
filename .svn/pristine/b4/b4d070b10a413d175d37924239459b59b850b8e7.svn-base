/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gk.myname.vn.entity;

import gk.myname.vn.utils.Tool;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 *
 * @author TUANPLA
 */
public class RouteUni {

    public static void main(String[] args) {
    }

    public static RouteUni json2Object(String str) {
        RouteUni result = new RouteUni();
        if (!Tool.checkNull(str)) {
            try {
                JSONObject obj = (JSONObject) JSONSerializer.toJSON(str);
                
                try {
                    JSONObject vteJson = (JSONObject) obj.get("vte");
                    UniLabel vte = (UniLabel) JSONObject.toBean(vteJson, UniLabel.class);
                    result.setVte(vte);
                } catch (Exception e) {
                    Tool.debug("Route table khong co VIETTEL:");
                }
                try {
                    JSONObject mobiJson = (JSONObject) obj.get("mobi");
                    UniLabel mobi = (UniLabel) JSONObject.toBean(mobiJson, UniLabel.class);
                    result.setMobi(mobi);
                } catch (Exception e) {

                    Tool.debug("Route table khong co MOBI FONE");
                }
                try {
                    JSONObject vinaJson = (JSONObject) obj.get("vina");
                    UniLabel vina = (UniLabel) JSONObject.toBean(vinaJson, UniLabel.class);
                    result.setVina(vina);
                } catch (Exception e) {
                    Tool.debug("Route table khong co VINA PHONE");
                }
                try {
                    JSONObject vnmJson = (JSONObject) obj.get("vnm");
                    UniLabel vnm = (UniLabel) JSONObject.toBean(vnmJson, UniLabel.class);
                    result.setVnm(vnm);
                } catch (Exception e) {
                    Tool.debug("Route table khong co VIETNAM MOBI");
                }
                try {
                    JSONObject blJson = (JSONObject) obj.get("bl");
                    UniLabel bl = (UniLabel) JSONObject.toBean(blJson, UniLabel.class);
                    result.setBl(bl);
                } catch (Exception e) {
                    Tool.debug("Route table khong co BEE LINE");
                }
                try {
                    JSONObject ddgJson = (JSONObject) obj.get("ddg");
                    UniLabel ddg = (UniLabel) JSONObject.toBean(ddgJson, UniLabel.class);
                    result.setDdg(ddg);
                } catch (Exception e) {
                    UniLabel ddg = new UniLabel();
                    ddg.setOperCode("DDG");
                    result.setDdg(ddg);
                    Tool.debug("Route table khong co DONG DUONG");
                }
                ///////////////////////////////
                try {
                    JSONObject lumitelJson = (JSONObject) obj.get("lumitel");
                    UniLabel lumitel = (UniLabel) JSONObject.toBean(lumitelJson, UniLabel.class);
                    result.setLumitel(lumitel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co lumitel");
                }
                
                try {
                    JSONObject africellJson = (JSONObject) obj.get("africell");
                    UniLabel africell = (UniLabel) JSONObject.toBean(africellJson, UniLabel.class);
                    result.setAfricell(africell);
                } catch (Exception e) {
                    Tool.debug("Route table khong co africell");
                }
                
                try {
                    JSONObject lacellsuJson = (JSONObject) obj.get("lacellsu");
                    UniLabel lacellsu = (UniLabel) JSONObject.toBean(lacellsuJson, UniLabel.class);
                    result.setLacellsu(lacellsu);
                } catch (Exception e) {
                    Tool.debug("Route table khong co lacellsu");
                }
                //////////////////////////////////////////
                try {
                    JSONObject nexttelJson = (JSONObject) obj.get("nexttel");
                    UniLabel nexttel = (UniLabel) JSONObject.toBean(nexttelJson, UniLabel.class);
                    result.setNexttel(nexttel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co nexttel");
                }
                
                try {
                    JSONObject mtnJson = (JSONObject) obj.get("mtn");
                    UniLabel mtn = (UniLabel) JSONObject.toBean(mtnJson, UniLabel.class);
                    result.setMtn(mtn);
                } catch (Exception e) {
                    Tool.debug("Route table khong co mtn");
                }
                
                try {
                    JSONObject orangeJson = (JSONObject) obj.get("orange");
                    UniLabel orange = (UniLabel) JSONObject.toBean(orangeJson, UniLabel.class);
                    result.setOrange(orange);
                } catch (Exception e) {
                    Tool.debug("Route table khong co orange");
                }
                /////////////////////////
                try {
                    JSONObject cellcardJson = (JSONObject) obj.get("cellcard");
                    UniLabel cellcard = (UniLabel) JSONObject.toBean(cellcardJson, UniLabel.class);
                    result.setCellcard(cellcard);
                } catch (Exception e) {
                    Tool.debug("Route table khong co cellcard");
                }
                
                try {
                    JSONObject metfoneJson = (JSONObject) obj.get("metfone");
                    UniLabel metfone = (UniLabel) JSONObject.toBean(metfoneJson, UniLabel.class);
                    result.setMetfone(metfone);
                } catch (Exception e) {
                    Tool.debug("Route table khong co metfone");
                }
                
                try {
                    JSONObject beelineCampuchiaJson = (JSONObject) obj.get("beelineCampuchia");
                    UniLabel beelineCampuchia = (UniLabel) JSONObject.toBean(beelineCampuchiaJson, UniLabel.class);
                    result.setBeelineCampuchia(beelineCampuchia);
                } catch (Exception e) {
                    Tool.debug("Route table khong co beelineCampuchia");
                }
                
                try {
                    JSONObject smartJson = (JSONObject) obj.get("smart");
                    UniLabel smart = (UniLabel) JSONObject.toBean(smartJson, UniLabel.class);
                    result.setSmart(smart);
                } catch (Exception e) {
                    Tool.debug("Route table khong co smart");
                }
                
                try {
                    JSONObject qbmoreJson = (JSONObject) obj.get("qbmore");
                    UniLabel qbmore = (UniLabel) JSONObject.toBean(qbmoreJson, UniLabel.class);
                    result.setQbmore(qbmore);
                } catch (Exception e) {
                    Tool.debug("Route table khong co qbmore");
                }
                
                try {
                    JSONObject excellJson = (JSONObject) obj.get("excell");
                    UniLabel excell = (UniLabel) JSONObject.toBean(excellJson, UniLabel.class);
                    result.setExcell(excell);
                } catch (Exception e) {
                    Tool.debug("Route table khong co excell");
                }
                //////////////////////////////////////
                try {
                    JSONObject telemorJson = (JSONObject) obj.get("telemor");
                    UniLabel telemor = (UniLabel) JSONObject.toBean(telemorJson, UniLabel.class);
                    result.setTelemor(telemor);
                } catch (Exception e) {
                    Tool.debug("Route table khong co telemor");
                }
                
                try {
                    JSONObject timortelecomJson = (JSONObject) obj.get("timortelecom");
                    UniLabel timortelecom = (UniLabel) JSONObject.toBean(timortelecomJson, UniLabel.class);
                    result.setTimortelecom(timortelecom);
                } catch (Exception e) {
                    Tool.debug("Route table khong co timortelecom");
                }
                /////////////////////////////////
                try {
                    JSONObject natcomJson = (JSONObject) obj.get("natcom");
                    UniLabel natcom = (UniLabel) JSONObject.toBean(natcomJson, UniLabel.class);
                    result.setNatcom(natcom);
                } catch (Exception e) {
                    Tool.debug("Route table khong co natcom");
                }
                
                try {
                    JSONObject digicelJson = (JSONObject) obj.get("digicel");
                    UniLabel digicel = (UniLabel) JSONObject.toBean(digicelJson, UniLabel.class);
                    result.setDigicel(digicel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co digicel");
                }
                
                try {
                    JSONObject comcelJson = (JSONObject) obj.get("comcel");
                    UniLabel comcel = (UniLabel) JSONObject.toBean(comcelJson, UniLabel.class);
                    result.setComcel(comcel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co comcel");
                }
                //////////////////////
                try {
                    JSONObject unitelJson = (JSONObject) obj.get("unitel");
                    UniLabel unitel = (UniLabel) JSONObject.toBean(unitelJson, UniLabel.class);
                    result.setUnitel(unitel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co UNITEL");
                }
                
                try {
                    JSONObject etlJson = (JSONObject) obj.get("etl");
                    UniLabel etl = (UniLabel) JSONObject.toBean(etlJson, UniLabel.class);
                    result.setEtl(etl);
                } catch (Exception e) {
                    Tool.debug("Route table khong co etl");
                }
                
                try {
                    JSONObject tangoJson = (JSONObject) obj.get("tango");
                    UniLabel tango = (UniLabel) JSONObject.toBean(tangoJson, UniLabel.class);
                    result.setTango(tango);
                } catch (Exception e) {
                    Tool.debug("Route table khong co tango");
                }
                
                try {
                    JSONObject laotelJson = (JSONObject) obj.get("laotel");
                    UniLabel laotel = (UniLabel) JSONObject.toBean(laotelJson, UniLabel.class);
                    result.setLaotel(laotel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co laotel");
                }
                //////////////////////////////
                try {
                    JSONObject mytelJson = (JSONObject) obj.get("mytel");
                    UniLabel mytel = (UniLabel) JSONObject.toBean(mytelJson, UniLabel.class);
                    result.setMytel(mytel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co MYTEL");
                }
                
                try {
                    JSONObject mptJson = (JSONObject) obj.get("mpt");
                    UniLabel mpt = (UniLabel) JSONObject.toBean(mptJson, UniLabel.class);
                    result.setMpt(mpt);
                } catch (Exception e) {
                    Tool.debug("Route table khong co mpt");
                }
                
                try {
                    JSONObject ooredoJson = (JSONObject) obj.get("ooredo");
                    UniLabel ooredo = (UniLabel) JSONObject.toBean(ooredoJson, UniLabel.class);
                    result.setOoredo(ooredo);
                } catch (Exception e) {
                    Tool.debug("Route table khong co ooredo");
                }
                
                try {
                    JSONObject telenorJson = (JSONObject) obj.get("telenor");
                    UniLabel telenor = (UniLabel) JSONObject.toBean(telenorJson, UniLabel.class);
                    result.setTelenor(telenor);
                } catch (Exception e) {
                    Tool.debug("Route table khong co telenor");
                }
                ////////////////////////////////////
                try {
                    JSONObject movitelJson = (JSONObject) obj.get("movitel");
                    UniLabel movitel = (UniLabel) JSONObject.toBean(movitelJson, UniLabel.class);
                    result.setMovitel(movitel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co MOVITEL");
                }
                
                try {
                    JSONObject mcelJson = (JSONObject) obj.get("mcel");
                    UniLabel mcel = (UniLabel) JSONObject.toBean(mcelJson, UniLabel.class);
                    result.setMcel(mcel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co mcel");
                }
                /////////////////////////
                try {
                    JSONObject bitelJson = (JSONObject) obj.get("bitel");
                    UniLabel bitel = (UniLabel) JSONObject.toBean(bitelJson, UniLabel.class);
                    result.setBitel(bitel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co bitel");
                }
                
                try {
                    JSONObject claroJson = (JSONObject) obj.get("claro");
                    UniLabel claro = (UniLabel) JSONObject.toBean(claroJson, UniLabel.class);
                    result.setClaro(claro);
                } catch (Exception e) {
                    Tool.debug("Route table khong co claro");
                }
                
                try {
                    JSONObject telefoniaJson = (JSONObject) obj.get("telefonia");
                    UniLabel telefonia = (UniLabel) JSONObject.toBean(telefoniaJson, UniLabel.class);
                    result.setTelefonia(telefonia);
                } catch (Exception e) {
                    Tool.debug("Route table khong co telefonia");
                }
                //////////////////////////////
                try {
                    JSONObject halotelJson = (JSONObject) obj.get("halotel");
                    UniLabel halotel = (UniLabel) JSONObject.toBean(halotelJson, UniLabel.class);
                    result.setHalotel(halotel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co halotel");
                }
                
                try {
                    JSONObject vodacomJson = (JSONObject) obj.get("vodacom");
                    UniLabel vodacom = (UniLabel) JSONObject.toBean(vodacomJson, UniLabel.class);
                    result.setVodacom(vodacom);
                } catch (Exception e) {
                    Tool.debug("Route table khong co vodacom");
                }
                
                try {
                    JSONObject zantelJson = (JSONObject) obj.get("zantel");
                    UniLabel zantel = (UniLabel) JSONObject.toBean(zantelJson, UniLabel.class);
                    result.setZantel(zantel);
                } catch (Exception e) {
                    Tool.debug("Route table khong co zantel");
                }
                
                //////////////////////////////
                try {
                    JSONObject chinamobileJson = (JSONObject) obj.get("chinamobile");
                    UniLabel chinamobile = (UniLabel) JSONObject.toBean(chinamobileJson, UniLabel.class);
                    result.setChinamobile(chinamobile);
                } catch (Exception e) {
                    Tool.debug("Route table khong co chinamobile");
                }
                
                try {
                    JSONObject chinaunicomJson = (JSONObject) obj.get("chinaunicom");
                    UniLabel chinaunicom = (UniLabel) JSONObject.toBean(chinaunicomJson, UniLabel.class);
                    result.setChinaunicom(chinaunicom);
                } catch (Exception e) {
                    Tool.debug("Route table khong co chinaunicom");
                }
                
                try {
                    JSONObject chinatelecomJson = (JSONObject) obj.get("chinatelecom");
                    UniLabel chinatelecom = (UniLabel) JSONObject.toBean(chinatelecomJson, UniLabel.class);
                    result.setChinatelecom(chinatelecom);
                } catch (Exception e) {
                    Tool.debug("Route table khong co chinatelecom");
                }
            } catch (Exception e) {
                Tool.debug("String json Route table not valid");
            }
        }

        return result;
    }

    public static String toStringJson(RouteUni route) {
        if (route != null) {
            JSONObject obj = JSONObject.fromObject(route);
            String str = obj.toString();
            return str;
        } else {
            return "";
        }
    }
    //****
    private UniLabel vte;
    private UniLabel mobi;
    private UniLabel vina;
    private UniLabel vnm;
    private UniLabel bl;
    private UniLabel ddg;

    public UniLabel getVte() {
        if (vte == null) {
            vte = new UniLabel();
        }
        return vte;
    }

    public void setVte(UniLabel vte) {
        this.vte = vte;
    }

    public UniLabel getMobi() {
        if (mobi == null) {
            mobi = new UniLabel();
        }
        return mobi;
    }

    public void setMobi(UniLabel mobi) {
        this.mobi = mobi;
    }

    public UniLabel getVina() {
        if (vina == null) {
            vina = new UniLabel();
        }
        return vina;
    }

    public void setVina(UniLabel vina) {
        this.vina = vina;
    }

    public UniLabel getVnm() {
        if (vnm == null) {
            vnm = new UniLabel();
        }
        return vnm;
    }

    public void setVnm(UniLabel vnm) {
        this.vnm = vnm;
    }

    public UniLabel getBl() {
        if (bl == null) {
            bl = new UniLabel();
        }
        return bl;
    }

    public void setBl(UniLabel bl) {
        this.bl = bl;
    }

    public UniLabel getDdg() {
        if (ddg == null) {
            ddg = new UniLabel();
        }
        return ddg;
    }

    public void setDdg(UniLabel ddg) {
        this.ddg = ddg;
    }
    ///////////////////////////////////////
    private UniLabel lumitel;
    private UniLabel africell;
    private UniLabel lacellsu;

    public UniLabel getAfricell() {
        if (africell == null) {
            africell = new UniLabel();
        }
        return africell;
    }

    public void setAfricell(UniLabel africell) {
        this.africell = africell;
    }

    public UniLabel getLacellsu() {
        if (lacellsu == null) {
            lacellsu = new UniLabel();
        }
        return lacellsu;
    }

    public void setLacellsu(UniLabel lacellsu) {
        this.lacellsu = lacellsu;
    }
    
    public UniLabel getLumitel() {
        if (lumitel == null) {
            lumitel = new UniLabel();
        }
        return lumitel;
    }

    public void setLumitel(UniLabel lumitel) {
        this.lumitel = lumitel;
    }
    /////////////////////////////////////
    private UniLabel nexttel;
    private UniLabel mtn;
    private UniLabel orange;

    public UniLabel getMtn() {
        if (mtn == null) {
            mtn = new UniLabel();
        }
        return mtn;
    }

    public void setMtn(UniLabel mtn) {
        this.mtn = mtn;
    }

    public UniLabel getOrange() {
        if (orange == null) {
            orange = new UniLabel();
        }
        return orange;
    }

    public void setOrange(UniLabel orange) {
        this.orange = orange;
    }
    
    public UniLabel getNexttel() {
        if (nexttel == null) {
            nexttel = new UniLabel();
        }
        return nexttel;
    }

    public void setNexttel(UniLabel nexttel) {
        this.nexttel = nexttel;
    }
    //////////////////////////////////////
    private UniLabel cellcard;
    private UniLabel metfone;
    private UniLabel beelineCampuchia;
    private UniLabel smart;
    private UniLabel qbmore;
    private UniLabel excell;

    
    public UniLabel getCellcard() {
        if (cellcard == null) {
            cellcard = new UniLabel();
        }
        return cellcard;
    }

    public void setCellcard(UniLabel cellcard) {
        this.cellcard = cellcard;
    }
    
    
    public UniLabel getMetfone() {
        if (metfone == null) {
            metfone = new UniLabel();
        }
        return metfone;
    }

    public void setMetfone(UniLabel metfone) {
        this.metfone = metfone;
    }
        
    public UniLabel getBeelineCampuchia() {
        if (beelineCampuchia == null) {
            beelineCampuchia = new UniLabel();
        }
        return beelineCampuchia;
    }

    public void setBeelineCampuchia(UniLabel beelineCampuchia) {
        this.beelineCampuchia = beelineCampuchia;
    }
    
    
    public UniLabel getSmart() {
        if (smart == null) {
            smart = new UniLabel();
        }
        return smart;
    }

    public void setSmart(UniLabel smart) {
        this.smart = smart;
    }
    
    
    public UniLabel getQbmore() {
        if (qbmore == null) {
            qbmore = new UniLabel();
        }
        return qbmore;
    }

    public void setQbmore(UniLabel qbmore) {
        this.qbmore = qbmore;
    }
    
    
    public UniLabel getExcell() {
        if (excell == null) {
            excell = new UniLabel();
        }
        return excell;
    }

    public void setExcell(UniLabel excell) {
        this.excell = excell;
    }
    ////////////////////////////////////
    private UniLabel telemor;
    private UniLabel timortelecom;    

    public UniLabel getTimortelecom() {
        if (timortelecom == null) {
            timortelecom = new UniLabel();
        }
        return timortelecom;
    }

    public void setTimortelecom(UniLabel timortelecom) {
        this.timortelecom = timortelecom;
    }
    
    public UniLabel getTelemor() {
        if (telemor == null) {
            telemor = new UniLabel();
        }
        return telemor;
    }

    public void setTelemor(UniLabel telemor) {
        this.telemor = telemor;
    }
    //////////////////////////////////////
    private UniLabel natcom;
    private UniLabel mpt;
    private UniLabel ooredo;
    private UniLabel telenor;

    public UniLabel getMpt() {
        if (mpt == null) {
            mpt = new UniLabel();
        }
        return mpt;
    }

    public void setMpt(UniLabel mpt) {
        this.mpt = mpt;
    }

    public UniLabel getOoredo() {
        if (ooredo == null) {
            ooredo = new UniLabel();
        }
        return ooredo;
    }

    public void setOoredo(UniLabel ooredo) {
        this.ooredo = ooredo;
    }

    public UniLabel getTelenor() {
        if (telenor == null) {
            telenor = new UniLabel();
        }
        return telenor;
    }

    public void setTelenor(UniLabel telenor) {
        this.telenor = telenor;
    }
    
    public UniLabel getNatcom() {
        if (natcom == null) {
            natcom = new UniLabel();
        }
        return natcom;
    }

    public void setNatcom(UniLabel natcom) {
        this.natcom = natcom;
    }
    //////////////////////////
    private UniLabel unitel;
    private UniLabel digicel;
    private UniLabel comcel;

    public UniLabel getDigicel() {
        if (digicel == null) {
            digicel = new UniLabel();
        }
        return digicel;
    }

    public void setDigicel(UniLabel digicel) {
        this.digicel = digicel;
    }

    public UniLabel getComcel() {
        if (comcel == null) {
            comcel = new UniLabel();
        }
        return comcel;
    }

    public void setComcel(UniLabel comcel) {
        this.comcel = comcel;
    }
    
    public UniLabel getUnitel() {
        if (unitel == null) {
            unitel = new UniLabel();
        }
        return unitel;
    }

    public void setUnitel(UniLabel unitel) {
        this.unitel = unitel;
    }
    //////////////////////////////////////////////
    private UniLabel mytel;
    private UniLabel etl;
    private UniLabel tango;
    private UniLabel laotel;

    public UniLabel getEtl() {
        if (etl == null) {
            etl = new UniLabel();
        }
        return etl;
    }

    public void setEtl(UniLabel etl) {
        this.etl = etl;
    }

    public UniLabel getTango() {
        if (tango == null) {
            tango = new UniLabel();
        }
        return tango;
    }

    public void setTango(UniLabel tango) {
        this.tango = tango;
    }

    public UniLabel getLaotel() {
        if (laotel == null) {
            laotel = new UniLabel();
        }
        return laotel;
    }

    public void setLaotel(UniLabel laotel) {
        this.laotel = laotel;
    }

    public UniLabel getMytel() {
        if (mytel == null) {
            mytel = new UniLabel();
        }
        return mytel;
    }

    public void setMytel(UniLabel mytel) {
        this.mytel = mytel;
    }
    ////////////////////////////////////////////////////
    private UniLabel movitel;
    private UniLabel mcel;

    public UniLabel getMcel() {
        if (mcel == null) {
            mcel = new UniLabel();
        }
        return mcel;
    }

    public void setMcel(UniLabel mcel) {
        this.mcel = mcel;
    }
    
    public UniLabel getMovitel() {
        if (movitel == null) {
            movitel = new UniLabel();
        }
        return movitel;
    }

    public void setMovitel(UniLabel movitel) {
        this.movitel = movitel;
    }
    /////////////////////////////////////////
    private UniLabel bitel;
    private UniLabel claro;
    private UniLabel telefonia;

    public UniLabel getClaro() {
        if (claro == null) {
            claro = new UniLabel();
        }
        return claro;
    }

    public void setClaro(UniLabel claro) {
        this.claro = claro;
    }

    public UniLabel getTelefonia() {
        if (telefonia == null) {
            telefonia = new UniLabel();
        }
        return telefonia;
    }

    public void setTelefonia(UniLabel telefonia) {
        this.telefonia = telefonia;
    }
    
    public UniLabel getBitel() {
        if (bitel == null) {
            bitel = new UniLabel();
        }
        return bitel;
    }

    public void setBitel(UniLabel bitel) {
        this.bitel = bitel;
    }
    //////////////////////////////////
    private UniLabel halotel;
    private UniLabel vodacom;
    private UniLabel zantel;

    public UniLabel getVodacom() {
        if (vodacom == null) {
            vodacom = new UniLabel();
        }
        return vodacom;
    }

    public void setVodacom(UniLabel vodacom) {
        this.vodacom = vodacom;
    }

    public UniLabel getZantel() {
        if (zantel == null) {
            zantel = new UniLabel();
        }
        return zantel;
    }

    public void setZantel(UniLabel zantel) {
        this.zantel = zantel;
    }
    
    public UniLabel getHalotel() {
        if (halotel == null) {
            halotel = new UniLabel();
        }
        return halotel;
    }

    public void setHalotel(UniLabel halotel) {
        this.halotel = halotel;
    }
    /////////
    private UniLabel chinamobile;
    private UniLabel chinaunicom;
    private UniLabel chinatelecom;

    public UniLabel getChinamobile() {
        if (chinamobile == null) {
            chinamobile = new UniLabel();
        }
        return chinamobile;
    }

    public void setChinamobile(UniLabel chinamobile) {
        this.chinamobile = chinamobile;
    }

    public UniLabel getChinaunicom() {
        if (chinaunicom == null) {
            chinaunicom = new UniLabel();
        }
        return chinaunicom;
    }

    public void setChinaunicom(UniLabel chinaunicom) {
        this.chinaunicom = chinaunicom;
    }

    public UniLabel getChinatelecom() {
        if (chinatelecom == null) {
            chinatelecom = new UniLabel();
        }
        return chinatelecom;
    }

    public void setChinatelecom(UniLabel chinatelecom) {
        this.chinatelecom = chinatelecom;
    }
}
