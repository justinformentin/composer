ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.15.0
docker tag hyperledger/composer-playground:0.15.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� t�Y �=�r�r�Mr�����*��>a��ZZ���pH����^EK�ěd���C�q8��B�R�T>�T����<�;�y�^ŋdI�w�~�HL��t7�Y�j�>���B��{u;F��k�O�L�#�0��BP�OĠ��1�<�pP
?��_�eC�'�	;�5o��_)t�ii��ϥ�g!������8 <�0w�g�Ͱ�f �[hw��=�Z�N��62uT�#30x>�R��M�rI��w�a��y�ʐ��Ll��a��G��b��!~�Keһ�g� ��Ox�U��o'ˇ�[ȆUhC�2�ay]B�ė�Ҷ�	��#d*Ֆf�* �ĺNVD��lZ1wT*��E�H%��4���F�o@�@��;���'�ٴy�Rm�i�&�i:Z����m�+��.j~Y���mw@������:�_XD�&U<nqb�N�^�����BC5��
M�JFQ������Bء��xج"����1�ߣCZ��S��f[�<�~t	[m��F��0�)��+łV��ZQ-�ղڙ�sd��l�x���l����m�I�U�Ǆ�t��e&2����w��`����Dd�����0S��̖.R�!M�!�|[��O֝�9�1����7��#�}�@v�M6�TQ:�7{�K��s�������>�,������*����O�4��<h������$��Oe1,=��d|��ߌ�	�p�p�W�ո/6����/J1eI�����:�_<�!Pь@Z��"�on���U5�zL��:��?�ʅx��σm��#hw��S���!	6��|ž��3��>��j�bpm������0���Pm�:�_X�xl�O���'�!���K�!Q��rP\��*�.:�ޛ���c;b���Q�tzk�md�"+����Y�ٲ5l��Z�M7�H�i٠�te��m�Z�T4�t+2y����w�;<u����YВ'�B���{�6ƺ��9oQ�C�n`sz�)��p��5��i ���E��$�"��V��ご�M���v��u�v�Ea�-���֨�Gӫ>h��ö������G���7�w�5@��E�;��� �kUCc4)&��Ǡ?�l�R_�Js�~y���>"��=�N=�!5�l�����3����'�ۡ���K�?�<��_��H8H�R"����J`<��做c��|`7����hT��Z��H!�c�Q���a%����m��Žͭ*S!ж���6���[M�$��a�<x���4��@j���!a{����� @6��z���2W�si�9�.��^����[�A�Q�}ڋ�a��^co�, -�E�İ�\�g�#�=�&�m��n�EkT�1�])2�F�6?�v���l��df��TG��6�Q�Li6�됱��Х蓘�O����`Ŋ���{䂄\��lV��^��c�n��rq��bp�?�����Tt�� �E6�g�s�Gko�)'���F���d�>�)3~����t�<o�@N���U�r�����l3sz@�D����q����W7+0���l�YP��@��k��?U����p���p(�^����?_7̰��X>�%�O����
GdA"� j��Z��*����}7:s7�͌H�Fc&�y��iV��1MJ�8�`��%2��O�&\i?S�P�2ǥ�_�kB^5����
������r�9��ʾ+䦔X!�p�,3G���Q��ż@��cX�~Ibt�iQ�!�I���
{ޡ"��O�P�+�盓���t�rS�bI)�>�2��Q�4_�	�Y��!�e!2XUk�F&j�!�4,4���?�|��/6١<"���[�9��ޟ������`�"a��\QwA�D�N��L����E�@�ui�,i�t�N x�J���_�x��F��jAP�I-⿢9l��W���F���w��>����?I�����:���a����C. ��P��$\��*���{��a�3���ADׁ��6QM����
�M�k�so�a�S��y���g������U���gK�{i�2���h�/	� ��p��ϡ�e�?B$85��`d}�o%0��7I��� �pӲ2Ml�mS3l�h������܇:t�G6}��Σ�O��8�����aӾ����m"�'��ņc�����w�t�>�z��Z�2"�3F^1��Ȅޤ�W��[��W�*��c��D�[!S��c�4u�B�����l�Y�g6�UGB!����ŞBݘ	�4ƈ�.Rq����a�u��;g�����]���,`�.Pu�u��[�����
_6�Gd��		�e����������A�|�^s�^���ذ��RȎ��xWA_�~�������@=���w����?�_�w�V�ѹK���x`GmT+U��m��>���H�z�'I!y��������,cK�7lP
��G?%&����Q���C����}^
-=�f�eѽ�!ɑ�����}��Q��swY���,������=��:�4�	{H�0k�X��$�_{UNm�p �0�[�
�,	�a0j�6����J|���G)��-{m�]���ҌgK����ڽdFY#�z��-�M2�%��x�;�StLԑ��`2���L^�6�R�̜1�}:YƬ��raL6u*�����Q6�_�Afy��y�R����AA�>G��;&3���@�@Zd*D�����^ɼ[�Ռ����|�on=�<�'����	
���U�����\��/�������HS��K�u�����[����o���w������������P�"��,Ewj���r�*5Y݉FõJT��D����D��
�h(+���T�	�6��[���rӄ7����Vi�u��/$��6����NoO���86,lښ������63ب����f���L��o��fD��߱\w�ƿl��w����i�������I�����O	���q
��6��
8?y�o'��y�n�,½�[����$��������*���n�6<������aa������X�	D�RC����Jc����$}��Y?h�M����7S�N��׼���>[�-|�AE�"�JMP#;Aa��E5U��QY
��
�T��eA��NF+b�(��P��ІԮy�Z�� m��B,���@<Y(eR��RJ��wF6���/�qE�וn&��3%�'��j ���7'�z���e�y��BHܮz�<$�fZ��X#?9�^&��B��;!�J�f�QI�J�O�����>SK��L���j+�I�ՙ�s�.)o\\J����s��Ѩ��Y���EE.�
tq����k�3[31��5�-���EFʖ2�Q)#�ҲV&����J6ou����I>�Nv_�����,�8ںx,{��R<=鶴P���<���n�/��wFYJ9��y��4t��.*W�Z6&0��=͟lxRH_�bHG锭�/��V�S)��IOƲ�X�c����J=��ǽ���"d�X��9����t�Xʞ��N$�F;;8�����B�ul�8l��D�B�v���5-���G����N��X��q!|.'{�z��T�f������&c�n���~=�di_��1���T.%�h���n���(�X�<�N$��E�f��=h}l��d�ё)�S�&��-w�
���`\�J6Y�g�q�:ȇ��d�c�t��x�F��E$�	��qZ�D;�j���Ca�ʽ�Uq
'�0��f����xs��?��֋��H��+��wS�d.1��~���8�F�P3���c��?����{6p�H��H�L����ۋ�=���'�����>���s�}+�%�����g��X����8鸐9!�8H��ҧ\6��'s��h����.�1T>_�L��0v��@TkV�O��#�D(�oP.}��=�@�U� oHN��\qE)����/�
�l�y���ȋ����
�?��f��/�z���B�})���S���S:��U%�(;���~I@-�6p6���|7��{�ˁ/c��o������
�l�S��M_Ó/c��f����������_�f�����Mv���폸�n�$����ו$�t�d*Q������i�	X"z]o��V�)��R�l3�T�p��9I��|��W�a��+ZZ�R�z)J}oo|���s��o>��{mӃ%5����[�J��{���C�����x��3ٹ�L,K��m?Pth�
��E��=��,�o|�n�[���[Ӑ�F�o	A�=j��{�Ȭ[<���i��NL�=��mH[�X��O�SK��Uv��!E��������<�@�r�GpF H�Ԍ]0v���?4oJ�/���F����h/�
�q�A��FG6c	�I&������e������+򠽷�bz��QTx �c�o]|T�e�G�;}<�����zȖ���,��0�,2`Ew��Kz�A��]��=�H���vL��;Q;&�+? Y��Z�K/0v���)�"PB����^���R��f��� �4a�2��D.�ԐEh'�0*�QޖFE"�v2U�U�ޞMY [�����b�����(��Xа�|�t��ct�ϰ����sP�f��	ʭf{ͣ	m�=�I�cjUD]ϐ�$к�i_�7�u����h��w'zl!����A��}?��jr��/$�妭�k�?�������[L��!izIj%bBϗ�DV�*Z�=��������ƤLk���� OJ��u�2>�W�P��86A�5d���� �O�X1X!83E�@sN���9��>�!���EO:��F��s%��$_G�-z���\�{A�xph��V�c�$�&rj�[�wk	��ıc�>q�vg�!�_od�TJ7U��̈́`�U�~�^����X�k��.�V�~���y���CG�p���6�v�SS����s�X��7�k��3�C�J�ۡB���;�"�+�`�@������L֔;��MT����1�\A粉G'DK���J�v�!=&��u]�?�a=��&|p�m�M��Z7��]�L�x�c�̧�'3t��}�1���G3����w-1�ci���i
w���N?�0C��t�.��#��s��c'q*��y�(9����<*v�$tY �h	�����Y��alF Do���s���ǭ��{Q紺n�}�������}��W��Hk
tkXn��;#|fkcYQ ���{���]���=���mm<�AL�l���?NF�M�/M��'!��#�/��Y�������_��ǽ�)���������7���_B��#����qd��������A�����5t1�)�}��#���ʘLF�(Uq��і��*M�X'�َ�J�� ���J���"Z����~�W����7/~�Ǳ�釟����A�����C��!��B�������������}�`���C?x�������5�\�ۃЗB�� �I���� 톋! -Vh1u�Ŋ\����b�cS���*e�W,�cN�n���?��E�9g� ]��^偫� ��)�m�pO,�FU�m�9��(5~���ȨI��!�7��y�ϛ��l�<+��1-�K&� ��W%�$Z�34���\�67�Ek���R�J2�]��p��-3�� 7n��X�[If8��=��<;���n�R�i���bɲR]��C�y�Q�vg��A5�/8�`�X�o��̂(ً�E�I��t�������
7�]5�d>S������[&��Y��fj�T��TO�u�$fq��%���(��k�MD&c{~D��B�$���8f����г%3���"��b7%��E��i��s!_�f��z#����h�m�������(r%��#t��9�W�M�!�]�D��N-��l��w�d�P�\cy��vB���+-�j�YbR�3�h)?7��Sa�J<R숱�QFWg�[�����妻`/��B/��"/��/���.���.���.���.��b.��B.��".�]��+�}y��f��[�'Eg��ZF)s@��j���%�gϗ8��51��.���R�Ί�bMI͗�=wQ=x(��V=�=�S=1+m7� ��ϛX+};��x����,�t��R��42g��q�EL-ڬI���B�%�Q��&�JK!B�g����@�ɊL6K����	N���H�PE�z��x��y�O�9b:�	&Nb2��ٲ�'�L�e�|i���"�V�W��.U?Y&=#�y���8����RV�`+��6jݸ��"f&�S���ԳQf��t�P�T���ѕf%?i�pr���$�=��2���_��v��^}:
�e����k���\��/��nxݼ�wo�f%�b�E�O8��`�oo#]k/B���9�Z�����Q7�~�Aݚ.{����q�BGv_��z���e�B�!�-|���������7��k>�у��~��<��kEYvi�2E^�|���򒡱�����R�V:�-�/K/Z�'9�������m+���(��Pr!���E[yz�����\�#���uE�enJ��V<	��7h� �D�I��vۮ�ؕ�Y�x�bD3��"�ē��NЙcn\P��E$N���T��\~�	�F�X`��v�k�Lb�R��8e��&��NmY$3]Mg�#<f!u��;R&u<T�rÓH����m��w�c
A{�� LӨ����pݢ�&X��/ˠ]��tRǉ�q4jʩх-����,�z5Fh���)��(��4ñ<�1Z]]��T�z����c�Z���z޶ ��B�Ơ_�ڈm�t�V^cF���h��=RW���a�&�gH�-�z�,�h��=��7�e�0�[��\ldPA���4��cټѝ�J�-�?~���"������rr�T=��z�~D|�b�:'��k,r��"��9}d?�g��̪��Y�ݑ������ϙ��=��K�[5}ZL�L�#�-�2Y�+��Ւs֕�B�@4R�4�U�\q8,��,zܯi��X�-�}�D�RV5�ViЌ����(�aLK���f��ˍ�\N�*\eD�re�1�"�X������%��nm0�Q�X �n2=�u���8Z�]��{:��E�r!T��TF�R�e��RQ�1�<=m�c5լ��t�/U�1�)Gg��tk _4E>=/�$�a��D�R�T��Hke:���2�r���3�R�H�b�e��s��y-O�$�H+E"�f��xXעS��Y�'G�-��jq�U$#+Ÿ�d���G������2An{�)de_�Ld{;�)�0�=�����+�rf)V�����ؠ�r�G
ԩ^��	���c>a0��5�e�K��ci��:/7r(ŚY<G�ʨ�KE�el:Ӑز7�
�4���d�E�-^����%ch���.R��*1os�/�bZڐ��Ba�^V+�X�Kf�bk>�)�Zc�S���f6@H��T|T>�w��VAe�*��T�,���fq�5y�#���l�k�r����U��ۥ��]�ˡo�6�À]�n蝠��"|���e"+��ƅ|���-ZRs�9_�BG^Ƈ���48�U��Ԑc5�^�-�Mc���,���be��+kK5�~��#�gϞ�={��|y�GI�wCo"o+��!_g�7���k��C�.^ n�M�Z��<}������ѻ#��� ���+2�q>F~���M�-P��8�8uG�k�����=wqE����!*����>?�C�^��E^ʬ!�9��]�-��<�9���k��atd��!���������/8���a������0�u:*�;��t����R�*􂯄{vf��~d��0V%�<��	�Ŏ���ڻ*���t���;"�F_����26�|f���=���H���I�3��*��� �t�l��g���m�3�z�폭�U^Ӣߪ���tT�ɎN��h��p�cjoo==vG�$�d�>�KA$�(r��>��òv� 䣃�"X�M�j�� =�]��Rߘf���?6y�-��� �.��Y�K'�`���h�+�j�,0( �r�� �+Sg�ZSӓ�e��
��U#��I 	����';X��K?����s���Nop�� 6�~�h�']�]E�U�3m2���2k�}й@mD�� k����+�8�
;S�
�ON�x�V(���c��Csk~#k��W�Tu^�4������X���;d� ��,0�Mƅ�^t=ɭ� �m��Ʋ~.��E^d��Z�.�J.'�/�^H���f����o"lo>�����;�4l�Fp�`C�~|��
�߮�M�.~=�D��W5�$��a@_�]�m�VO�����@t��T��K�^o����0�y�ŗЀ9Թ�V�� >������
�0HJ����4���|nu�Z]����EP�͖]����А�b�	�l} �u�dMT"[W��h�R����]E�>����u �U���w���=�L�t�2�]�?�� ��Q_��ev�6� �8m�[�'<_����O1��1��_y P�P�؏A?-Y:#�T�n�����Y�I�0�k)�΂ލ����2k��I .�rXǚF��a�)���6�v5`W;V'{( ?�=n�ܭ�!c�֘�=�S[��fمiO�3W���v[ �p?��uPY�N4Y�������ؓ��s��[v���"�]Z_�b�F����޿0�=��	p�mڊ��^�����!�&T�i��U��m��j>���&��;#��ON-��Q��úf@��y�-�$p�� ����@E��ğ <tX(����Ñ�n�xmm�i��>����8'V�"x9�5��.���E�[@8BSq7��t"�����}7��f��5��]��n)�pḡzl?�@(�����1�ɮ�}-vp�7\�}��<���v��k۸��?%"��o��o�?���#���)�)� �ڎU�#�#+a0��D���=�$Ö��Y�9�1����FwV��䎂e�T�K�cW�����W�ϒB���v���?g���k:��׎L�܉Pt�����LE�ա�N��vp%��e�hE�����:qZ&ɘ*�|f�A�^�r�#a�	����|l��~�����?��<C�1Cn<��O�Sg_]<_�x\nє�j�02�EY�	�lcr\�e�&�j��15"�BB��3��dT�eZV�	?n9�N�ϱ~�|
gcf�m50]O���;�e�䦣q��Ov�ܓ�E�v�]����wd��cw���m�%�/�T��s|�ɞe�,_�O�5�^�M(K|��_.?Šu�]��[�"/���Sx�M�����_ra�A%��X.�����u�A���.��w��U@@��;�3�Π���vG�\5&m����i���Z�3��b��-��o�A�io��7]kٞ�����C0ۭnΐ������~�a��$���RzO�K< �K�x��A��}"��D�[�tx���Jj=kU<�s\!/䤧ӡ6?AQܳFg��L��m���',	?�)��ӣ`^��.�Mx���7.�8����e)��%��Y��j�ҩh���Fg�K�덮��s ���~��^`��6π�̲Z�K�e�#��O���)�O �)�^�?��$����˛ /b*��/�A}�-�O���L>�Ⱥ�^����"�xc0��eL���:Mݝ�o����,���vs��:߲]��d�X��`�:V��q��0����Fu���n���ͮ��;V�ߊw�#�=���v���@!t����3����:��������M�M��$N��AR8}����t�����m�t�W�?m�=rX�}���[2�6�!���a��?���)|��7v����t��o�F[�M��C�C����B�ӑ���Kz�?�c�򟊒����/�^�I�eO�W6�K�_����������}/����������z�y�,�\镰�����^Ҿ�?U���.��b1��)�-;HSZ��V����JǰX'ҎP�H+J����8I��3㾨�^���Ʒ��C�������&��Z��64��H����r\�:hZl���E��H�a��yu��^�O5����)�-c���ƌV"*�5�&�+-
��XE;����y٘����I9�8�t��IOO'�,���6L�ƨ�]����v���*������K�/�l���!�N�X�ۜ������>ҫ �	l��� ����%�/������A�����wm͉�]��_��[5r>\�U/'�|��'PT�_�jҙ�i�I:݁g:{]YN&iEk���z���;���8��*P3��&��~>5����k���ž�@�W��i�6.Q� ��������Y��*��?���D�CU��O�4���?IC��
�Q�pT'�����) ����0�Q	���m���s�?$����� ���?�� �����$	����k��u���͟��J7�/x�m�]�1��-���ϲ���Аҗ�O��������9�������~b���,���ɬ
��߷������,�`��¯VyC+��E��z�E���U�9�n��:Q̅�*�:_G���Z�a��
�E�j�'����=t��2���ϗ�O�G�>��a��r5���;���.S,R�=Y�$�����|������/�es�.��Wc〝~͔����F��r>�i������'��eX�4���Ploy���?V{]�"GŬ���r����H�?�����ӂ(X � ��ϭ��������R������'������O���O����	��
 ���$���� ����H���g��� �W����A���@����������s������s&�S1=�s��uk�X7u~��+������KY_x��Ő����^��7��4 �Z����6�]p�vÍfc�ϴx�Q]V�2��pz��{���!���ow�1;��Sidxh��C�45*뱿���h��S]�>�Ȇ(�sI��d��R�/m|쥏��6�}��CK[�:�����tJ��Ӳ�b�m���v�XSn/��d6���m1�Ιb��EhҒ4�WL��QC+�M>���1B:2Fsj���o@B����
 ��V�%?���� ����(�?��g�)���� %�����1q��1<�<�3�DxD|��!�K�,�T�TȆ%P�pF������5����y����9��A��4Y,Os��/�s��u*:˖1��A[���o���ޞ�������Uw/rv$䬍M=o����)ܦ�͖��|�)q�����>�D�,Ț1���������(��!��>�|�?���[+P��C�W�����������Z��f|B���P�Շ_Y�MKu���8m�1����Y1Xw�۫�v�yː��<=��j�b��H�̈́��K�v���}�l.�ya'�,�=_��0�)�*��n\օԙ�=�l�������N7��c��{+и���������G����P������ �_���_����z�Ѐu 	��qw���@�U����W^�_�~�����-�~t�L��Y!�D=O���g�Z��Kq�����s쪶?s ���O��}�g�p��a{���C���x� �:�Sz��b��;��^�[r����4ZMI�Z��]ڶ2l�eH6bs8�q�DTg�1�~���s!xW�f헂y�n��X�Y��8��n9O�W��`�-�0�k=��b�%]�'&.�p`@���N3���>�$%����FR��b���I����I�zn����e-�!���ڛh��KMʘ4y����B�P-YSG:��Y��ώ�2�өޑ�d:W��K��n7��|����fd�}�"S��>lR�C�;c��Y2����r��n.��h���#����W>���0�.����������'��?>(�?�?����%���!�YT��?��;������C�?��C���O��ׄJ�!���A�4�s3F����>��B��<�G��n�A�I�x!����Y?���
����_�?��W��z��*��e������h$�g�,腹�%ktj1ї�_{��,V�.饑n���w��(��vCI�,��I'Յ�ߌ/#]z-y�;��Bo���k9�>NmZ0��V�p�'�����S	>��ou�J�ߡ������H��� �����0�W���I �E �����$y����_E�������B;T��?��Nq��U�W��o��P�:�m�ۑٸ̚R��N�$UWk�n�;,k��VD�e�[%��3�߷簟��������.��5�1#>�TK���w���g�"ګ����w��I2��K��*l<t�Rg�[�G�z�Χ�.�-f'	cp�e�6���l0d=Z���B_:��3D���z��s����vb����f��GN�$�{�B�첍�����q��	�e:��鱗c�P]Y�d:�-��x8ӈ��R`�Bs����1����H8ɳf��6�����^fi+U3_�
C��66���'����t�"�cٕ�wU{p�oM�F������ϭ�P��� ��&T��0�P���S��W	`��a�濡������a���$��������}������
�����R��U �!��!�������o�_����1��Һ_'�1�����i��+
�O��}�O�W������?���?����ׅ���!j�?���O<�� �_	���������?������h�?�CT����G�h���� ������) ���;��?*�6Cj���[�!������E@��a-��P�?��!��@��?@��?@��_M��!j���[�!�����h�?�CT$���4�?T�������z����+�/Ob��P�n���?6���p�{%@��a��r�P���}�������u	�S@B����
 ��V�%?���� ����(�?��g��(�?A\�`�G���)���B4���"�`X~��!E�O�/���O����G}�_���K@�_���Cmt���OW�/��s�8��@�6^�7o��b׊^O�Ӥ)$��ż�8�mb���z}Z��(,���%���hʢ8ܟ��r�af�����\��y�6�(���ʽXC�´��:d;���x�����bSq����q�hI�"5䯥�݋��G(��!��>�|�?���[+P��C�W�����������Z��f|B���P�Շ_Y�B�`΍C�)Z���a�Foɝ�`V����E·���[�K��D��}��f٤�����,Yk>Y��y�|-��Ĺ����(�a�\L�s[�v�2�Sd֌
�ҵ���.�1��{+и�ߝ��oE@��������7 ��/������_���_�������X���/�#�����5����k����n:�䱼g���ʗ'^���7���W�gmw�v��I^�Ȃ�c��%��z�~�9a���V���4b�C��L	v�D��ph�'�݋�,>��c}�.Ų<�9���%��lF�����fn����v���;}��{�t�m��r[RaH���^�Ֆt�׉K��^]蓾�i�� 2ۧ��<Q��H*7���9�Sv?7iW��B�P-Y�p���	����D0�T�ϴ��<��͹w����(4ڽ�����'3��
=?ՈY�Z3A$�8�L�Ft�Q��|�1�����+����g���[����_�&�6B��C��
|������^�o����J�B�G��?a��|���)�F��E������I��W��ĉ��/�_����\O��@U��?�p��W�g������#����5��0O+�N�h�ԛ-|ʸ�����?Z�h������Ҵh?;n��W��J��{��0�œ函�܏����Y�����Kߐ��rx�.o��-��6�d숎�_�VM���T����Q��Y#g��@���oTa���U�ʹ8��ɳl-&ղ�d��{j6��#Lv���hѦ�%<%_.�)�G�?�h�'+��}�/�����R<Uo�EE��~��;ק�NӐ�>3%�I�8�7uvTC�v۲�#b�o+�i,#�*{l��F���e�͎�H��H䢗ؼD�t����`f���9�d"��i��k����n�Z,%nӗ
�<ŏ�&(�=��ԦB�/��c��+����~/@B�1w������?.`��%(?��<A��0�B¿>M��0�i�zß�C����Oq2!�GxH�`����B�?��0�W	~�����s���� 	����l?���<F�s�m>#�}����+ߪ�=r�V`���������}G��!��� 
���{��_%����¨��������,�J���+o����������4��S�v6��?ߩ���֗�:�`���������[�9����w���7xCr_������b�ao��,*9�K*�V�;�2�m(� j--L`���τa�7�L;�d��D_��(o�(̳vq8{����q9ٴ�q�e����������~����r�Hb3NDw�nȣ��v���|Q�-;]�Em�*E{����$���v@8w��M8z5�_K�g���oVnb���A�ṥ̉�B�Fz5�Ӷ7֖]�j��n�/�X����P����������0by���9O���_�^1\̓��	��y��_«��C�$�\�!x���Q���q��bq������ku�M�&"�������΂:��z�L�=��P�3+��������Z�����ފ����~���q�_@A�]�޽��A�U�*���m�NxD����u�?�Շ���9�AȠ*����~W�s$������|��<�њv���n,���|������>�!����!i/����}�_{���&�����+�����r���NM�*@D����[@^> E������D���M���Jb���k�����#7���X[�Υ��~���&��Xnզu!�����=��^��{�h!>]f��o����\a�KW.�����a}��Wۮ�e%���u�J���Ǒ;�w❭�:Or*E��:�պ��7էRq9v�������'3�%���JЌ���Ϋ��bY��ӟnT�%F7Jx�\�K��?�����%��ς���s�x�oѾ��P�]o�w���ٱ�iڂ�2l��yd�Һ*��O����ҶMcR��ld*��r0���gw
Ɨ-9Yk�YKl�{��rvm@U��d-��+�,g�!��~�!�
N��@��~E9����4y���[�C�O&d��8�y���������:��������?�2�g�B�'�B�'���������p�%��߷�����td��P.g��������?��g���oP��A�w��~D�^��U�G������6�B�٫��P�3#������r�?�?z���㿙�J�Oエ� ��G��$q��?eJ������G��ԍ�_��,ȉ�C]Dd��_W��¡�C6@��� ��\����_�����$�������r������y��AG.������C��L��P��?@����/k��B������r��0�����?ԅ@D.��������&@��� �������`�'P��kC�?b���o�/�Oݨ� �_�����T�����d@�?��C�����g`�(���y�b?4��G���m��A��ĕ��?dD.��`H�0q���iͨR$��u�J��ais�\�M����A1�e�U-�BS&^��2�3���Gݺ?=y��2s��C�6���;=y��E��8���R��E�ŷ$����-���_��׉��%<�Ncݮ�0ǵ��e����*����I�U�F�|3��o��ǝ��-�j�$yP��"Y�7�JT��ھM�%�
�\��]��i
�_�zk���u1f��f^y����+�u���Au������]]��y����':P���
f}�@���Б���t����>�n �V�_������{��f�Hi[�u�qi��X�6�I�0�q���j��m\_l�i���5�Ѳ=Wۃ�Z7B��o��51�i���R�F�U�R�m���(�M����ӋC,-盅2��9��B��$Dڱ����R����a�(�C{4�Q�B�"���_���_���?`�!�!���h������������������qX"��zVq�J"�g����O�����k|��ID�/�O�@~��`�z���e�o��q��q�ݟŇ����cM�ۺ7)��܏�+7l�[s�X�jj���d�i�Z�ܴV�<(k]m[�D�}ء��B��G���s��駬c~��?�r��x��쐷�:�5j�i
ɔ����w�q϶���D '��b��D�ƹ��|�M>��'�6_�sE���G�݄At%���YUR����1��um�%O{~��VbQ��z�P��$���b�n�UR���ҥ�a��!�Z��׸����|�Ƀ�G�P�	?����=rJ�������8�Y��go����Y�����x]�����������i�����JC� w�?�?r�'n����O& ��W���n�{����S7�? �7��P2{������x���������P��~Ʌ�G���/���$R���o�/��? #7��?"!�?s��K@�G&|6��x���>��qe�D.���Ud{fnW�� ��#�w_�?�9��X�}[���9���e؟��8�~`_��;i��K�o���{���,�[v�~���z��2�kAǬ/�X��P�]s^]j{����Qt�xg�6�ᄵnQ %�~FqQ�'�b�r��Ni�ط��^�~�y��.�.ϕl�ZRQY6�$����P����3�����5��y��;1��D҉�3\�G>0',���ac�^�F��01�fzԖ�^xԭYD��=ӡVfq����B�J��Z�K�Af��������d ��^-��-������˅���?2���/a Sr��ߨ�E��&@�/������Z����D ��>,��)������˅��8�?"r��7���M.���G����Z��������͆sד*#E��������}�?I$�2<��uoe�G�K��� `/�y�P�E�zuw����H�Y�k�QbX_Qf���o��T%��-�ͨ���ί��>�zN�<rJ�Q�7�L��}cQ����9 �)	��� `�$�?��%\��d{�\��p]B�v�x1wL��l�aGYt�Qu�;��w����Z��C���Ks;M�,���D��3LQ�&DWMt�����o&�qc����	�������n���������e�F��2��G��*�Z��,F3�jE3�e\'-�J'h�"I�R5i°p��-�6L�e�j�%��.�Q���L��������s��;c�.�U���,`��HBՈŨ׏&�^[��usW���?Ń?!K͝]4�P��V�c)����
����8�]�4u��+̱���q�Qbw/����Q�%ѲB�I�C_t�	����������@����B� wN���Б���d ���E S7uS�%y�����=��`�]��E]�H
_��X�����W����U�;-|������c��2��|�zԪ$$�SsLcA|�#z��G�� ��A����S(fܖt��X�W��(8��UdM�E����������Y
��,@��, ��\�A�2 �� ��`��?��?`�!�M���C���������ߓc���u�Y��x���������=��o��.��(.�h��D&�hZ�(�lPT�$R���VӍ�S7GU�Hͧ*�,��Ŭ����O�.��buhi��i��7�ʬ�n��j!����fv��x�K�;��V��Ly�;lp�iL0����'-��|�VIdz�%{�*ɋ��ReA/����h�1����x�)��x!=_�7�r6QV�KlHO���m��"�I�@�$b^���S�H������xF!��ae��5��D�ۻ�'�hc���j��0;b��#Rq�fcfw��)�#��*��3�Z�?�}}���������?N���G�ORE��g��;�M���1C-6/��/�w��m�*�>�øP���,��һ7h��3�a�����pA�[��,/wN�l*H��DnTx�q����o,������Q?m��#
��y��r(!4��ys�}P��fz�.��Z���|>�?�/}�OOI\��9_����#�9��a)�,��!Ig��ς��WIw���E��� �ݸ�{���`����������Ĭ5o=b��]����F�9}��ӫmhb\Oh�򟭧�S9Y��td)��B�c�fz���{���ɽ_޼�G��N���?����<�o�뷇=A�_��~{S��7����$��UzT��#�������;���߅y�"'8o+<X���>���^�K��p�mPx���>��v����8f�2�ΏS!��OW���Zzx�:7}TH�T�­繞]X�����Yp�hk>�������~��JO��m׺�f�_x��}â�i��5=������<_sz�QL3���&^;��o_�/�C<����bqO�Sa>5wɌ����J���ȟNV�]��N)m�W���U<�7����:��{��w��Z���N��$N	��$��?���o��a��}�?���n�t�?>�ﲏ                           �����O � 