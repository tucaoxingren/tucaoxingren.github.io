		Document doc = null;
		try {
			doc = DocumentHelper.parseText(outData);
			Element rootElt = doc.getRootElement(); // 获取根节点
			System.out.println("根节点：" + rootElt.getName()); // 拿到根节点的名称
			Iterator iter = rootElt.elementIterator("outputdata"); // 获取根节点下的子节点outputdata
			// 遍历outputdata节点
			while (iter.hasNext()) {
				Element itemEle = (Element) iter.next();
				transcode = itemEle.elementTextTrim("transcode"); // 拿到outputdata下的子节点transcode的值
				insurancetype = itemEle.elementTextTrim("insurancetype");
				areano = itemEle.elementTextTrim("areano");
			}
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // 将字符串转为XML
		
		
		
				String transcodePattern = "<transcode>*</transcode>";
		String insurancetypePattern = "<insurancetype>*</insurancetype>";
		String areanoPattern = "<areano>*</areano>";
		inDto.put("INPUTDATA", outData.);