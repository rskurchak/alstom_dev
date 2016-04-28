@font-face {
    font-family: 'AlstomRegular';
    src: url('../ComFONTS/alstom-regular.eot');
    src: url('../ComFONTS/alstom-regular.eot') format('embedded-opentype'),
         url('../ComFONTS/alstom-regular.woff') format('woff'),
         url('../ComFONTS/alstom-regular.ttf') format('truetype'),
         url('../ComFONTS/alstom-regular.svg#AlstomRegular') format('svg');
}
@font-face {
    font-family: 'AlstomLight';
    src: url('../ComFONTS/alstom-light.eot');
    src: url('../ComFONTS/alstom-light.eot') format('embedded-opentype'),
         url('../ComFONTS/alstom-light.woff') format('woff'),
         url('../ComFONTS/alstom-light.ttf') format('truetype'),
         url('../ComFONTS/alstom-light.svg#AlstomLight') format('svg');
}
@font-face {
    font-family: 'AlstomMedium';
    src: url('../ComFONTS/alstom-medium.eot');
    src: url('../ComFONTS/alstom-medium.eot') format('embedded-opentype'),
         url('../ComFONTS/alstom-medium.woff') format('woff'),
         url('../ComFONTS/alstom-medium.ttf') format('truetype'),
         url('../ComFONTS/alstom-medium.svg#AlstomMedium') format('svg');
}
@font-face {
    font-family: 'AlstomBold';
    src: url('../ComFONTS/alstom-bold.eot');
    src: url('../ComFONTS/alstom-bold.eot') format('embedded-opentype'),
         url('../ComFONTS/alstom-bold.woff') format('woff'),
         url('../ComFONTS/alstom-bold.ttf') format('truetype'),
         url('../ComFONTS/alstom-bold.svg#AlstomBold') format('svg');
}

body { 
  padding-bottom: 0px;
}

.btn {
	border-radius:0px;
  font-family: AlstomRegular, Sans-serif;
  font-size: 16px;
}
.carousel {
	margin-top:-106px;
}
.carousel .item {
	background: none;
	height:380px;
}
.carousel-inner > .item > img {
    height:auto;
    min-height:380px;
    left: 0; top: 0;
    min-width: 100%;
    position: absolute;
}
.carousel-caption{
	text-align: left;
}
.carousel-caption p {
	font-size:16px;
	font-family: AlstomLight, Sans-serif;
}
.carousel .homeBg {
	min-width:700px;
}
.training-details-header-orange {
  width:100%; text-align: center; min-width: 700px; height: 222px; float: left;
  background:url(../img/public_trainings_header_railway.png) no-repeat top left;
}
.training-details-header-green {
  width:100%; text-align: center; min-width: 700px; height: 222px; float: left;
  background:url(../img/public_trainings_header_maintenance.png) no-repeat top left;
}
.training-details-header-purple {
  width:100%; text-align: center; min-width: 700px; height: 222px; float: left;
  background:url(../img/public_trainings_header_operation.png) no-repeat top left;
}
.training-details-header-turquoise {
  width:100%; text-align: center; min-width: 700px; height: 222px; float: left;
  background:url(../img/public_trainings_header_management.png) no-repeat top left;
}
.training-details-header-orange h1 {
  font-family: AlstomMedium, Sans-serif; font-size: 50px; color: #ffffff;
}
.training-details-header-green h1 {
  font-family: AlstomMedium, Sans-serif; font-size: 50px; color: #ffffff;
}
.training-details-header-purple h1 {
  font-family: AlstomMedium, Sans-serif; font-size: 50px; color: #ffffff;
}
.training-details-header-turquoise h1 {
  font-family: AlstomMedium, Sans-serif; font-size: 50px; color: #ffffff;
}

.training-details-header-container {
  width: 90%;
  margin-right: auto;
  margin-left: auto;
}
.training-details-header-container a {
  color:#ffffff;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.6);
}
.training-details-header-container a:hover {
  text-decoration: underline;
}
.training-details-navLeft {
  border:2px solid #ffffff;
  border-radius:2px;
  font-family: AlstomBold, Sans-serif;
  font-size: 16px;
  color: #ffffff;
  width:146px; height:44px;
  padding-top: 12px;
  background:url(../img/public_trainings_details_arrow_left.png) no-repeat 20px center;
  float: left;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.6);
}
.training-details-navRight {
  border:2px solid #ffffff;
  border-radius:2px;
  font-family: AlstomBold, Sans-serif;
  font-size: 16px;
  color: #ffffff;
  width:146px; height:44px;
  padding-top: 12px;
  background:url(../img/public_trainings_details_arrow_right.png) no-repeat 114px center;
  float: right;
  box-shadow-shadow: 0 1px 2px rgba(0, 0, 0, 0.6);
}
/* nav colors */
/* orange */
.training-details-nav-orange {
  width: 100%; height: 44px; float: left; list-style-type: none; margin-bottom: 0px;
  background-color: #f7941d;
}
.training-details-nav-orange li {
  height: 44px; float: left;
  background-color: #f7941d;
}
.training-details-nav-orange li:first-child{
  padding-left: 31px;
}
.training-details-nav-orange li > a {
  line-height: 44px; height: 44px; font-family: Arial, Sans-serif; font-size: 14px; text-transform: uppercase; color: #ffffff; text-decoration: none; padding: 14px 25px 14px 25px;
}
.training-details-nav-orange li > a:hover, .training-details-nav-orange li > a.active {
  text-decoration: none;
  background-color: #fab767;
}
/* /orange */
/* green */
.training-details-nav-green {
  width: 100%; height: 44px; float: left; list-style-type: none; margin-bottom: 0px;
  background-color: #328f3a;
}
.training-details-nav-green li {
  height: 44px; float: left;
  background-color: #328f3a;
}
.training-details-nav-green li:first-child{
  padding-left: 31px;
}
.training-details-nav-green li > a {
  line-height: 44px; height: 44px; font-family: Arial, Sans-serif; font-size: 14px; text-transform: uppercase; color: #ffffff; text-decoration: none; padding: 14px 25px 14px 25px;
}
.training-details-nav-green li > a:hover, .training-details-nav-green li > a.active {
  text-decoration: none;
  background-color: #76b47b;
}
/* /green */
/* purple */
.training-details-nav-purple {
  width: 100%; height: 44px; float: left; list-style-type: none; margin-bottom: 0px;
  background-color: #52397b;
}
.training-details-nav-purple li {
  height: 44px; float: left;
  background-color: #52397b;
}
.training-details-nav-purple li:first-child{
  padding-left: 31px;
}
.training-details-nav-purple li > a {
  line-height: 44px; height: 44px; font-family: Arial, Sans-serif; font-size: 14px; text-transform: uppercase; color: #ffffff; text-decoration: none; padding: 14px 25px 14px 25px;
}
.training-details-nav-purple li > a:hover, .training-details-nav-purple li > a.active {
  text-decoration: none;
  background-color: #8b7aa6;
}
/* /purple */
/* turquoise */
.training-details-nav-turquoise {
  width: 100%; height: 44px; float: left; list-style-type: none; margin-bottom: 0px;
  background-color: #00b7b2;
}
.training-details-nav-turquoise li {
  height: 44px; float: left;
  background-color: #00b7b2;
}
.training-details-nav-turquoise li:first-child{
  padding-left: 31px;
}
.training-details-nav-turquoise li > a {
  line-height: 44px; height: 44px; font-family: Arial, Sans-serif; font-size: 14px; text-transform: uppercase; color: #ffffff; text-decoration: none; padding: 14px 25px 14px 25px;
}
.training-details-nav-turquoise li > a:hover, .training-details-nav-turquoise li > a.active {
  text-decoration: none;
  background-color: #54cfcb;
}
/* /green */
/* /nav colors */

.training-details-container-wrapper {
  width: 100%;
  margin-right: auto;
  margin-left: auto;
  text-align: center;
  background-color: #f2f2f2;
  float:left;
}
.training-details-maincontainer {
  width: 90%;
  margin-right: auto;
  margin-left: auto;
  background-color: #ffffff;
  /*float:left;*/
  margin-top: 39px;
}
.training-details-footercontainer {
  width: 90%;
  margin-right: auto;
  margin-left: auto;
}
.training-details-formation_text {
  position:relative;
  top:-70px;
  font-family: AlstomBold, Sans-serif;
  text-transform: uppercase;
  font-size: 14px;
  color:#464646;
  width:90%;
  padding-left: 36px;
}
.training-details-formation-orange {
  width:33.3%; float:left; background-color: #ffffff;
  background:#ffffff url(../img/btn_more31_orange_enable.png) no-repeat center 194px;
}
.training-details-formation-orange:hover {
  text-decoration: underline;
  background:#ffffff url(../img/btn_more31_orange_rollover.png) no-repeat center 194px;
}
.training-details-formation-orange img {
  width: 340px; height: 210px;
}
.training-details-formation-green {
  width:33.3%; float:left; background-color: #ffffff;
  background:#ffffff url(../img/btn_more31_green_enable.png) no-repeat center 194px;
}
.training-details-formation-green:hover {
  text-decoration: underline;
  background:#ffffff url(../img/btn_more31_green_rollover.png) no-repeat center 194px;
}
.training-details-formation-green img {
  width: 340px; height: 210px;
}
.training-details-formation-purple {
  width:33.3%; float:left; background-color: #ffffff;
  background:#ffffff url(../img/btn_more31_purple_enable.png) no-repeat center 194px;
}
.training-details-formation-purple:hover {
  text-decoration: underline;
  background:#ffffff url(../img/btn_more31_purple_rollover.png) no-repeat center 194px;
}
.training-details-formation-purple img {
  width: 340px; height: 210px;
}
.training-details-formation-turquoise {
  width:33.3%; float:left; background-color: #ffffff;
  background:#ffffff url(../img/btn_more31_turquoise_enable.png) no-repeat center 194px;
}
.training-details-formation-turquoise:hover {
  text-decoration: underline;
  background:#ffffff url(../img/btn_more31_turquoise_rollover.png) no-repeat center 194px;
}
.training-details-formation-turquoise img {
  width: 340px; height: 210px;
}
/* responsive */
@media (max-width: 1239px) {
  .training-details-formation_text {
    top:-66px;
    font-size: 13px;
  }
  .training-details-formation-orange img {
    width: 272px; height: 168px;
  }
  .training-details-formation-orange {
    background:#ffffff url(../img/btn_more31_orange_enable.png) no-repeat center 155px;
    background-size: 25px;
  }
  .training-details-formation-orange:hover {
    background:#ffffff url(../img/btn_more31_orange_rollover.png) no-repeat center 155px;
    background-size: 25px;
  }
  .training-details-formation-green img {
    width: 272px; height: 168px;
  }
  .training-details-formation-green {
    background:#ffffff url(../img/btn_more31_green_enable.png) no-repeat center 155px;
    background-size: 25px;
  }
  .training-details-formation-green:hover {
    background:#ffffff url(../img/btn_more31_green_rollover.png) no-repeat center 155px;
    background-size: 25px;
  }
  .training-details-formation-purple img {
    width: 272px; height: 168px;
  }
  .training-details-formation-purple {
    background:#ffffff url(../img/btn_more31_purple_enable.png) no-repeat center 155px;
    background-size: 25px;
  }
  .training-details-formation-purple:hover {
    background:#ffffff url(../img/btn_more31_purple_rollover.png) no-repeat center 155px;
    background-size: 25px;
  }
      .training-details-formation-turquoise img {
    width: 272px; height: 168px;
  }
  .training-details-formation-turquoise {
    background:#ffffff url(../img/btn_more31_turquoise_enable.png) no-repeat center 155px;
    background-size: 25px;
  }
  .training-details-formation-turquoise:hover {
    background:#ffffff url(../img/btn_more31_turquoise_rollover.png) no-repeat center 155px;
    background-size: 25px;
  }
}
/* /responsive */
.training-details-title1 {
  /*float:left;*/
  padding:40px 40px 40px 40px;
  text-align: left;
}

/* Modals */
.modal-header {
  border:0px;
}
.modal-footer {
  border:0px;
  text-align: center;
  padding: 0px 20px 30px;
}
.modal-content {
  padding: 10px 20px 10px 20px;
}
.modal-header > .close {
  background: url(../img/btn_close31_enable.png) no-repeat center center!important;
  width: 31px; height: 31px;
  opacity: 1;
}
.modal-header > .close:hover {
  background: url(../img/btn_close31_rollover.png) no-repeat center center!important;
  width: 31px; height: 31px;
  opacity: 1;
}
.trainings-modal-title {
  font-family: AlstomMedium, Sans-serif;
  text-transform: uppercase;
  font-size: 20px;
  color:#464646;
}
.trainings-modal-img {
  width: 100%;
  border-radius: 4px;
}

.trainings-modal-litext {
  font-family: Arial, Sans-serif;
  font-size: 14px;
  color: #000000;
}
.modal-body > ul {
  margin-bottom: 0px;
}
.modal-body > ul li {
  list-style-type: square;
  margin-left: -25px!important;
  padding-bottom: 5px;
  font-size: 20px;
  line-height: normal;
}
/* colors */
/* orange */
.orange {
  background-color: #f7941d!important;
  border-color: #f7941d!important;
}
.orange:hover {
  background-color: #fab767!important;
  border-color: #fab767!important;
}
.trainings-modal-title-orange {
  font-family: AlstomMedium, Sans-serif;
  text-transform: uppercase;
  font-size: 20px;
  color:#f7941d;
  padding: 30px 0 8px 0;  
}
.modal-body-orange > ul li {
  color: #f7941d!important;
}
/* /orange */
/* green */
.green {
  background-color: #319648!important;
  border-color: #319648!important;
}
.green:hover {
  background-color: #76b47b!important;
  border-color: #76b47b!important;
}
.trainings-modal-title-green {
  font-family: AlstomMedium, Sans-serif;
  text-transform: uppercase;
  font-size: 20px;
  color:#319648;
  padding: 30px 0 8px 0;  
}
.modal-body-green > ul li {
  color: #319648!important;
}
/* /green */
/* purple */
.purple {
  background-color: #52397b!important;
  border-color: #52397b!important;
}
.purple:hover {
  background-color: #8b7aa6!important;
  border-color: #8b7aa6!important;
}
.trainings-modal-title-purple {
  font-family: AlstomMedium, Sans-serif;
  text-transform: uppercase;
  font-size: 20px;
  color:#52397b;
  padding: 30px 0 8px 0;  
}
.modal-body-purple > ul li {
  color: #52397b!important;
}
/* /purple */
/* turquoise */
.turquoise {
  background-color: #00b7b2!important;
  border-color: #00b7b2!important;
}
.turquoise:hover {
  background-color: #54cfcb!important;
  border-color: #54cfcb!important;
}
.trainings-modal-title-turquoise {
  font-family: AlstomMedium, Sans-serif;
  text-transform: uppercase;
  font-size: 20px;
  color:#00b7b2;
  padding: 30px 0 8px 0;  
}
.modal-body-turquoise > ul li {
  color: #00b7b2!important;
}
/* /green */
/* /colors */

/* /Modals */


/* trainings-details pagination */
.trainings-pagePrev {
  background:#ffffff url(../img/public_trainings_btn_before.png) no-repeat center center;
  margin-right: 8px;
  padding: 10px;
}
.trainings-pagePrev:hover {
  background:#ffffff url(../img/public_trainings_btn_before_rollover.png) no-repeat center center;
  text-decoration: none;
}
.trainings-pageNext {
  background:#ffffff url(../img/public_trainings_btn_next.png) no-repeat center center;
  margin-left: 8px;
  padding: 10px;
}
.trainings-pageNext:hover {
  background:#ffffff url(../img/public_trainings_btn_next_rollover.png) no-repeat center center;
  text-decoration: none;
}

.trainings-pageNumber-orange {
  line-height: 25px; font-family: Arial, Sans-serif; font-size: 14px; color: #ffffff; border-radius: 3px; padding:0 12px 0 12px;
  background-color: #f7941d; border: 4px solid #f7941d;
}
.trainings-pageNumber-green {
  line-height: 25px; font-family: Arial, Sans-serif; font-size: 14px; color: #ffffff; border-radius: 3px; padding:0 12px 0 12px;
  background-color: #328f3a; border: 4px solid #328f3a;
}
.trainings-pageNumber-purple {
  line-height: 25px; font-family: Arial, Sans-serif; font-size: 14px; color: #ffffff; border-radius: 3px; padding:0 12px 0 12px;
  background-color: #52397b; border: 4px solid #52397b;
}
.trainings-pageNumber-turquoise {
  line-height: 25px; font-family: Arial, Sans-serif; font-size: 14px; color: #ffffff; border-radius: 3px; padding:0 12px 0 12px;
  background-color: #00b7b2; border: 4px solid #00b7b2;
}

/* /training-details pagination */
.navbar-alstom .navbar-nav{
	margin-top:10px;
  max-width: 552px;
}
.navbar-alstom .navbar-nav > li > a.btn {
    padding-bottom: 5px;
    padding-top: 7px;
    margin-top:7px;
    color:#fff;
}
.navbar-alstom .navbar-nav > li {
    text-align: center;
}
.navbar-alstom .navbar-nav > li > a.btn:hover, .navbar-nav > li > a.btn:focus {
    background-color: #3276B1;
    border-color: #285E8E;
    color: #FFFFFF;
}
.navbar-alstom .navbar-nav > .active > a {
  background-color: #fff;
}
.navbar-alstom .navbar-nav a {
  font-family: AlstomMedium, Sans-serif;
  text-transform: uppercase;
  color:#334d8c;
}

.navbar-alstom .navbar-nav .nav-home-select a:hover, .navbar-alstom .navbar-nav .nav-home-select a:focus {
  background-color: transparent;
  background:url(../img/public_trainings_nav_home_selected.png) no-repeat 2px 5px;
}
.navbar-alstom .navbar-nav .nav-contactus-select a:hover, .navbar-alstom .navbar-nav .nav-contactus-select a:focus {
  background-color: transparent;
  background:url(../img/public_trainings_nav_contactus_selected.png) no-repeat 3px 5px;
}
.navbar-alstom .navbar-nav .nav-about-select a:hover, .navbar-alstom .navbar-nav .nav-about-select a:focus {
  background-color: transparent;
  background:url(../img/public_trainings_nav_lang_selected.png) no-repeat 3px 5px;
}
.navbar-alstom .navbar-nav .nav-myportal-select a {
  background-color: transparent;
  background:url(../img/public_trainings_nav_myportal_unselected.png) no-repeat 0px 5px;
  color: #ffffff;
}
.navbar-alstom .navbar-nav .nav-myportal-select a:hover, .navbar-alstom .navbar-nav .nav-myportal-select a:focus {
  background-color: transparent;
  background:url(../img/public_trainings_nav_myportal_selected.png) no-repeat 0px 5px;
  font-family: AlstomMedium, Sans-serif;
  color:#334d8c;
}
.navbar-alstom .navbar-nav .nav-lang-select a:hover, .navbar-alstom .navbar-nav .nav-lang-select a:focus {
  background-color: transparent;
  background:url(../img/public_trainings_nav_lang_selected.png) no-repeat 5px 5px;
}

.navbar-alstom .navbar-brand,
.navbar-alstom .navbar-nav > li > a {
  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
}
.navbar-wrapper .navbar {
  border-radius: 0px;
  background-color: #ffffff;
}
.navbar-header img{
	padding: 15px 0 15px 0;
}
.btn {
  background-color: #7c7c7c;
  border-color: #7c7c7c;
  color: #FFFFFF;
}
.btn:hover {
  background-color: #2b4277;
  border-color: #2b4277;
  color: #FFFFFF;
}
.btn-primary {
    background-color: #334d8c;
    /*border-color: #357EBD;*/
    border-color: #334d8c;
    color: #FFFFFF;
}
.btn-darkblue {
  font-size: 14px;
  background-color: #203159;
  border-color: #203159;
  border-radius: 4px;
  margin:10px 0 0 50px;
}
.btn-gray {
  background-color: #7c7c7c; border-color: #7c7c7c;
  color: #FFFFFF;
}
.btn-gray:hover {
  background-color: #515151; border-color: #515151;
}
.btn-round {
  border-radius: 4px;
}
.btn-monportail {
  width:150px;
  font-size:14px;
  background: #334d8c url(../img/public_trainings_btn_mon-portail.png) no-repeat 10px 4px;
}
.btn-chooseFormation {
  font-family: AlstomMedium, Sans-serif;
  font-size: 16px;
  color: #ffffff;
  background-color: #334d8c;
  border-color: #334d8c;
  line-height: 1.7;
  border-radius: 4px;
  background: #334d8c url(../img/public_trainings_chooseformation_arrow.png) no-repeat 186px 16px;
} 
.btn-chooseFormation:hover, .btn-chooseFormation.active, .open .dropdown-toggle.btn-chooseFormation {
  background-color: #ffffff;
  border: 2px solid #334d8c;
  color: #334d8c;
  background: #ffffff url(../img/public_trainings_chooseformation_arrow_over.png) no-repeat 186px 16px;
}
.dropdown-chooseFormation {
  min-width: 217px;
  margin-left: 61px;
  background: url(../img/public_trainings_popover.png) no-repeat 140px top!important;
}
.chooseFormation-dropdown-first {
  border-top: 2px solid #334d8c!important;
  border-left: 2px solid #334d8c!important;
  border-right: 2px solid #334d8c!important;
  border-radius: 4px 4px 0 0;
  padding-top: 5px;
  background-color:white;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.175);
}
.chooseFormation-dropdown {
  border-left: 2px solid #334d8c!important;
  border-right: 2px solid #334d8c!important;
  font-family: AlstomMedium, Sans-serif;
  font-size: 14px;
  background-color:white;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.175);
}
.chooseFormation-dropdown a {
  color: #464646;
  height: 20px;
}
.chooseFormation-dropdown .arrow_gray, .chooseFormation-dropdown-last .arrow_gray {
  background: url(../img/public_trainings_chooseformation_arrow_gray.png) no-repeat center 5px;
}
.chooseFormation-dropdown-last {
  font-family: AlstomMedium, Sans-serif;
  font-size: 14px;
  border-bottom: 2px solid #334d8c!important;
  border-left: 2px solid #334d8c!important;
  border-right: 2px solid #334d8c!important;
  border-radius: 0 0 4px 4px;
  padding-bottom: 10px;
  background-color:white;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.175);
}
/* dropdown-menu */
.dropdown-menu {
  background-color: #334d8c;
  background: url(../img/public_trainings_popover.png) no-repeat center top;
  border:0px;
  box-shadow: none;
}
.navbar-alstom .navbar-nav .dropdown-menu a {
  font-family: AlstomRegular, Sans-serif;
  font-size: 14px;
  color: #ffffff;
  text-transform: none;
}
.navbar-alstom .navbar-nav .dropdown-menu a:hover {
  font-family: AlstomRegular, Sans-serif; font-size: 14px;
  border-color: #285E8E;
  color: #FFFFFF;
  background: #3276B1;
}
.navbar-alstom .navbar-nav .dropdown-menu li {
  background-color: #334d8c;
  padding: 5px 0 5px 0;
  border-top: 1px solid #3d5692;
}
.navbar-alstom .navbar-nav .dropdown-menu .dropdown-first {
  border-radius: 6px 6px 0px 0px;
  border-top: 0px;
}
.navbar-alstom .navbar-nav .dropdown-menu .dropdown-last {
  border-radius: 0px 0px 6px 6px;
}
.navbar-alstom .navbar-nav .dropdown-menu .noborder a {
  border-top: 0px;
}

.dropdown-lang {
  background: url(../img/public_trainings_btn_langue.png) no-repeat 20px 12px;
}
.dropdown-lang > a {
  background: url(../img/public_trainings_btn_langue.png) no-repeat 20px 12px; z-index: 10000;
}
.nav-lang-dropdown {
  border-top-color:#334d8c!important;
  border-bottom-color:#334d8c!important;
  border-top: 8px solid #000000;
  border-right: 5px solid transparent;
  border-left: 5px solid transparent;
}
.nav-formation-dropdown {
  border-top-color:#FFFFFF!important;
  border-bottom-color:#FFFFFF!important;
  border-top: 8px solid #000000;
  border-right: 5px solid transparent;
  border-left: 5px solid transparent;
}
.navbar-alstom .navbar-nav .dropdown-menu .nav-myportal-form a {
  background: #334d8c;
}
.navbar-alstom .navbar-nav .dropdown-menu .nav-myportal-form {
  border-radius: 6px 6px 6px 6px;
  width: 241px;
  height: 213px;
  padding-left:20px;
}
.nav-myportal-form {
  font-family: AlstomMedium, Sans-serif;
  color:#999999;
  padding-top: 2px;
  text-align: left;
}
.nav-myportal-form form {
  padding-top: 1px;
}
.nav-myportal-form input[type=text] {
  line-height: 2.3;
  padding-left: 8px;
  border-radius: 4px;
  border: 0; 
  margin-top: 10px;
}
.nav-myportal-formtext {
  color: #ffffff;
  font-size: 12px;
  font-family: AlstomRegular, Sans-serif;
  padding-top: 12px;
  line-height: 2;
}
.nav-myportal-formtext a {
  font-size: 12px!important;
  text-decoration: underline;
}
.nav-myportal-form input[type=checkbox] {
  background-color: #ffffff;
  float:left;
}
/* /dropdown-menu */

/* Training */
/* titles */
.training-title1 {
  font-family: AlstomLight, Sans-serif;
  text-transform: uppercase;
  font-size: 24px;
}
.training-title1bold {
  font-family: AlstomMedium, Sans-serif;
  text-transform: uppercase;
  font-size: 24px;
}
.training-title2bold {
  font-family: AlstomBold, Sans-serif;
  text-transform: uppercase;
  font-size: 20px;
  margin-bottom: 10px;
}
.training-title3bold {
  font-family: AlstomBold, Sans-serif;
  text-transform: uppercase;
  font-size: 20px;
  margin-bottom: 10px;
  color: #3c3c3c;
}
.training-title4bold {
  font-family: AlstomMedium, Sans-serif;
  text-transform: uppercase;
  font-size: 28px;
}
.training-title3 {
  font-family: AlstomMedium, Sans-serif;
  font-size: 18px;
  margin-bottom: 10px;
}
.training-title4 {
  font-family: AlstomMedium, Sans-serif;
  font-size: 18px;
  margin-bottom: 10px;
  color: #334d8c;
}
.FormationTitle1 {
  font-family: AlstomMedium, Sans-serif;
  font-size: 16px;
  color: #f7941d!important;
  padding-top: 8px!important;
  padding-bottom: 0px!important;
  height: 26px;
}
.FormationTitle2 {
  font-family: AlstomMedium, Sans-serif;
  font-size: 16px;
  border-top: 1px solid #C0C0C0;
  padding-top: 10px!important;
  color: #319648!important;
  height: 29px!important;
}
.FormationTitle3 {
  font-family: AlstomMedium, Sans-serif;
  font-size: 16px;
  border-top: 1px solid #C0C0C0;
  padding-top: 10px!important;
  color: #52397b!important;
  height: 29px!important;
}
.FormationTitle4 {
  font-family: AlstomMedium, Sans-serif;
  font-size: 16px;
  border-top: 1px solid #C0C0C0;
  padding-top: 10px!important;
  color: #00b7b2!important;
  height: 29px!important;
}
/* /titles */

/* legends */
.training-legend1 {
  font-family: Arial, Sans-serif;
  font-size: 10px;
}
/* /legends */

/* texts */
.training-tetiaire1 {
  margin-top: 20px;
  width: 660px;
  font-family: Arial, Sans-serif;
  font-size: 14px;
}
.training-tetiaire2 {
  margin-top: 20px;
  font-family: Arial, Sans-serif;
  font-size: 14px;
}
/* /texts */
.training-container {
  max-width: 90%;
  padding-left: 0px;
  padding-right: 0px;
}
.training-container2 {
  max-width: 100%;
}
.training-container3 {
  padding: 35px 0px 0px 0px;
}
.training-container4 {
  padding: 44px 0px 0px 0px;
}
.training-container5 {
  margin-top: 44px;
  margin-bottom: 39px;
}
.training-container6 {
  background-color: #f2f2f2;
}
.training-container7 {
  padding-top: 40px;
  padding-bottom: 39px;
}
.training-container8 {
  padding: 35px 0px 60px 0px;
}

.training-carousel {
  margin-bottom: 0px;
}
.training-maintitle {
  left: 10%;
  width: 660px;
  bottom: -20px;
}
.training-maintitle p {
  /*padding-top: 8px;*/
  line-height: 1.2;
}
.training-maintitle h1 {
  font-family: AlstomMedium, sans-serif;
  font-size: 50px;
  margin-bottom: 16px;
}
.training-maincontent {
  left: 10%;
  right: 10%;
}
.training-content1 {
  margin: 0 10% 0 10%;
}
.training-bloc1-col1 {
  text-align: center;
  font-family: Arial, sans-serif; font-size: 14px; color:white;
  height:288px;
  background: url(../img/public_trainings_section_railway.png) no-repeat center center;
  padding-top: 139px;
  float: left;
  width: 25%;
}
.training-bloc1-col2 {
  text-align: center;
  font-family: Arial, sans-serif; font-size: 14px; color:white;
  height:288px;
  background: url(../img/public_trainings_section_maintenance.png) no-repeat center center;
  padding-top: 139px;
  float: left;
  width: 25%;
}
.training-bloc1-col3 {
  text-align: center;
  font-family: Arial, sans-serif; font-size: 14px; color:white;
  height:288px;
  background: url(../img/public_trainings_section_operations.png) no-repeat center center;
  padding-top: 139px;
  float: left;
  width: 25%;
}
.training-bloc1-col4 {
  text-align: center;
  font-family: Arial, sans-serif; font-size: 14px; color:white;
  height:288px;
  background: url(../img/public_trainings_section_management.png) no-repeat center center;
  padding-top: 139px;
  float: left;
  width: 25%;
}

.training-bloc2-col1 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color:#666666; padding-top: 139px; width:20%; float:left;
  background: url(../img/public_trainings_knowledge_cours-sur-place.png) no-repeat top center;
}
.training-bloc2-col2 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color:#666666; padding-top: 139px; width:20%; float:left;
  background: url(../img/public_trainings_knowledge_e-learning.png) no-repeat top center;
}
.training-bloc2-col3 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color:#666666; padding-top: 139px; width:20%; float:left;
  background: url(../img/public_trainings_knowledge_realite-virtuelle.png) no-repeat top center;
}
.training-bloc2-col4 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color:#666666; padding-top: 139px; width:20%; float:left;
  background: url(../img/public_trainings_knowledge_equipements-physiques.png) no-repeat top center;
}
.training-bloc2-col5 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color:#666666; padding-top: 139px; width:20%; float:left;
  background: url(../img/public_trainings_knowledge_formation-chez-vous.png) no-repeat top center;
}

.training-bloc4-col1 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color: #464646; padding-top: 48px;
  width: 193px; width: 193px; width: 193px; height:275px;
  background: url(../img/public_trainings_processus_step1.png) no-repeat top center;
}
.training-bloc4-col2 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color: #464646; padding-top: 48px;
  width: 193px; width: 193px; width: 193px; height:275px;
  background: url(../img/public_trainings_processus_step2.png) no-repeat top center;
}
.training-bloc4-col3 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color: #464646; padding-top: 48px;
  width: 193px; width: 193px; height:275px;
  background: url(../img/public_trainings_processus_step3.png) no-repeat top center;
}
.training-bloc4-col4 {
  text-align: center; font-family: Arial, sans-serif; font-size: 14px; color: #464646; padding-top: 48px;
  width: 193px; height:275px;
  background: url(../img/public_trainings_processus_step4.png) no-repeat top center;
}

.training-process-separator {
  background: url(../img/public_trainings_processus_line.png) repeat-x center center;
  width:100%;
  height: 275px;
  width: 964px; 
  margin-left: auto;
  margin-right: auto;
}

#training-map1 {
  width: 640px; height: 325px; margin-top: 40px;
  background: url(../img/public_trainings_knowledge_map1-texte.png) no-repeat top center;
}

/* lists */
.training-list1 li {
  list-style-type: square;
  font-family: AlstomMedium, Sans-serif;
  font-size: 18px; color: #464646;
  margin: 10px 0 0 -10px;
  cursor: pointer;
  list-style-image : url(../img/public_trainings_puce_unselected.png);
  padding-left: 6px;
}
.training-list1 li:hover {
  color: #334d8c;
  list-style-image : url(../img/public_trainings_puce_selected.png);
}
/* /lists */

/* icons */
.icon-download {
  background: url(../img/public_trainings_btn_download.png) no-repeat 0 0;
  background-size:25px 25px;
  width: 25px;
  float: left;
}
.icon-contact {
  background: url(../img/public_trainings_contact-formation.png) no-repeat 0px 8px;
  background-size:60px 60px;
  width: 76px; height:70px;
  float: left;
}
/* /icons */
/* /training */

/* spareparts */
.spareparts-fiche-header {
  width:100%;
  text-align: center;
  min-width: 700px;
  height: 222px;
  background:url(../img/public_spareparts_header.png) no-repeat top left;
  float: left;
}
.spareparts-fiche-header h1 {
  font-family: AlstomMedium, Sans-serif;
  font-size: 50px;
  color: #ffffff;
}
.spareparts-fiche-searchbox {
  font-family: AlstomBold, Sans-serif;
  font-size: 16px;
  color: #ffffff;
  width:288px; height:44px;
  padding-top: 8px 31px 0 0;
  margin-top: 26px;
  background:url(../img/public_searchbox_overlay.png) no-repeat top center;
  float: right;
}

.spareparts-fiche-searchbox input {
  color: #ffffff;
  background-color: transparent;
  border:none;
  margin-top: 11px;
}
.spareparts-fiche-searchbox input:focus {   
    border-color: transparent;
    box-shadow: 0 1px 1px transparent inset, 0 0 8px transparent;
    outline: 0 none;
}
.spareparts-fiche-searchbox input:-moz-placeholder { color:#ffffff }
.spareparts-fiche-searchbox input:-ms-input-placeholder { color:#ffffff }
.spareparts-fiche-searchbox input::-webkit-input-placeholder { color:#ffffff }

.spareparts-breadcrumb {
  width: 90%;
  margin-right: auto;
  margin-left: auto;
  /*float:left;*/
  margin-top: 19px;
  font-family: Arial, Sans-serif; font-size: 11px; color:#595959;
  text-align: left;

}
.spareparts-fiche-maincontainer {
  width: 90%;
  margin-right: auto;
  margin-left: auto;
  background-color: #f2f2f2;
  /*float:left;*/
  margin-top: 40px;
}
.spareparts-vspacer {
  width: 40px;
  float: left;
  background-color: #f2f2f2;
}
.spareparts-fiche-colg {
  width:28%;
  background-color: #ffffff;
  float: left;
  min-height: 978px;
  line-height: 1.3;
}
.spareparts-fiche-cold {
  width:66%;
  background-color: #ffffff;
  margin-left: 40px;
  float: left;
  min-height: 978px;
  text-align: left;
  padding: 28px 40px 60px 40px;
  font-family: Arial, Sans-serif; font-size: 14px;
  color:#464646;
  line-height:1.3;
}
.spareparts-fiche-colg h1 {
  font-family: AlstomMedium, sans-serif;
  font-size: 20px;
  color:#334d8c;
  padding:15px 0 0 40px;
  text-align: left;
}
.spareparts-fiche-cold h1 {
  font-family: AlstomMedium, sans-serif;
  font-size: 30px;
  color:#595959;
  margin-top: 0px;
}
.spareparts-fiche-cold h2 {
  font-family: AlstomMedium, sans-serif;
  font-size: 20px;
  color:#334d8c;
  margin-top: 40px;
  text-transform: uppercase;
}
.spareparts-fiche-cold h3 {
  font-family: AlstomMedium, sans-serif;
  font-size: 24px;
  color:#464646;
  margin-top: 0px;
  margin-bottom: 0px;
  text-transform: uppercase;
}
.spareparts-fiche-colg .list-group {
  margin-top: 36px;
  text-align: left;
}
.spareparts-fiche-colg .list-group-item {
  font-family: Arial, Sans-serif;
  font-size: 14px;
  text-transform: uppercase;
  color:#595959;
  padding: 18px 0 18px 40px;
  margin-bottom: 0px;
  border: none;
}
.spareparts-fiche-colg .list-group-item:hover {
  background-color:#4d649b;
  color:#ffffff;
}
.spareparts-fiche-colg .list-group-item.active {
  background-color:#3c5080; border-color:#3c5080;
  color:#ffffff;
}
.spareparts-fiche-colg .list-group-item:first-child {
  border-radius: 0;
}
.spareparts-fiche-imgcontainer {
  float:right;width:292px;height:342px;margin:33px 0 20px 10px;
}
#spareparts-fiche-imgdisplay {
  width:292px;height:292px;
}
#spareparts-fiche-imgthumbnail {
  width:292px;height:50px;margin-top:8px;
}
.spareparts-thumbnail {
  padding:0;
}
.spareparts-thumbnail img.active, .spareparts-thumbnail img:visited, .spareparts-thumbnail img:focus {
  border: 2px solid #334d8c;
  border-radius: 2px;
  margin: -2px;
}
.spareparts-thumbnail img:hover {
  border: 2px solid #4d649b;
  border-radius: 2px;
  margin: -2px;
}
.spareparts-fiche-cold > ul {
  margin-bottom: 0px;
}
.spareparts-fiche-cold > ul li {
  list-style-type: square;
  margin-left: -21px!important;
  padding-bottom: 5px;
  font-size: 20px;
  line-height: normal;
  color: #334d8c!important;
}
.spareparts-litext {
  font-family: Arial, Sans-serif;
  font-size: 14px;
  color: #464646;
}
.spareparts-fiche-cold a {
  color:#334d8c;
  text-decoration: underline;
}
.blue {
  background-color: #334d8c!important;
  border-color: #334d8c!important;
}
.blue:hover {
  background-color: #2b4277!important;
  border-color: #2b4277!important;
}
.spareparts-fiche-cold a.btn.btn-large.blue {
  color: #ffffff;
  text-decoration: none;
}
.spareparts-cat {
  margin:41px 34px 0 0;
  width:340px;
  height:260px;
  float:left;
  border:2px solid #f2f2f2;
  border-radius: 6px;
  text-align: center;
  font-family: AlstomBold, Sans-serif;
  font-size: 18px;
  text-transform: uppercase;
  color:#334d8c;
}
.spareparts-cat-img {
  width:340px;
  height:166px;
  margin:-2px;
  margin-bottom: 34px;
  //padding-bottom: 39px;
}
.spareparts-catlist-content {
  
}
.spareparts-cat-home {
  margin: 40px 34px 0 0;
  width: 340px;
  height: 260px;
  float: left;
  border: 2px solid #f2f2f2;
  border-radius: 6px;
  text-align: center;
  font-family: AlstomBold,Sans-serif;
  font-size: 18px;
  text-transform: uppercase;
  color: #334d8c;
}
/* /spareparts */

/* footer */
.footer{
  height:58px;
  clear:both;
  border-top:5px solid #1b3e95;
  padding-top:10px;
  background-color: #ffffff;
  margin-top: 50px;
}
.footer .fLinks{
  float:left;
  font-family: AlstomMedium, sans-serif;
}
.fLinks a{
  color:#8a8a8a !important;
  display:inline-block;
  min-width:100px;
  padding:5px 5px 5px 25px;
  text-decoration:none;
  /*font-weight:bold;*/
  font-size:14px;
}
.fLinks a:first-child{
  border-left:none;
}
.fLinks a{
  border-left:1px solid #ccc;
}
.fLinks a:hover{
  text-decoration: underline;
}
.footer .ressoc{
  float:right;
}
.footer .ressoc a{
  width:32px;
  height:32px;
  display:inline-block;
  margin: 0 5px;
}
.ytb{
  background:url("../img/footer_share_youtube_enable.png") no-repeat ;
}
.ytb:hover{
  background:url("../img/footer_share_youtube_rollover.png") no-repeat ;
}
.ytb:active, .ytb:focus {
  background:url("../img/footer_share_youtube_pressed.png") no-repeat ;
}
.dlm{
  background:url("../img/footer_share_daily_enable.png") no-repeat ;
}
.dlm:hover{
  background:url("../img/footer_share_daily_rollover.png") no-repeat ;
}
.dlm:active, .dlm:focus {
  background:url("../img/footer_share_daily_pressed.png") no-repeat ;
}
.twt{
  background:url("../img/footer_share_twitter_enable.png") no-repeat ;
}
.twt:hover{
  background:url("../img/footer_share_twitter_rollover.png") no-repeat ;
}
.twt:active, .dlm:focus {
  background:url("../img/footer_share_twitter_pressed.png") no-repeat ;
}
.fcb{
  background:url("../img/footer_share_facebook_enable.png") no-repeat ;
}
.fcb:hover{
  background:url("../img/footer_share_facebook_rollover.png") no-repeat ;
}
.fcb:active, .dlm:focus {
  background:url("../img/footer_share_facebook_pressed.png") no-repeat ;
}
.inn{
  background:url("../img/footer_share_linkedin_enable.png") no-repeat ;
}
.inn:hover{
  background:url("../img/footer_share_linkedin_rollover.png") no-repeat ;
}
.inn:active, .dlm:focus {
  background:url("../img/footer_share_linkedin_pressed.png") no-repeat ;
}
/* /footer */