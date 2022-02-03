//
//  TimelineInfoViewController.swift
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class TimelineInfoViewController: InfoViewController {
    
    let headerText = InfoHeader(text: "timelineInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let topText = InfoText(text: "timelineTopInfo".localize())
    let locationText = InfoText(text: "timelineLocationInfo".localize())
    let iconTextInfo = IconInfoText(icon: "text.alignleft", text: "timelineTextIconInfo".localize())
    let iconImageInfo = IconInfoText(icon: "camera", text: "timelineImageIconInfo".localize())
    let iconAudioInfo = IconInfoText(icon: "mic", text: "timelineAudioIconInfo".localize())
    let iconVideoInfo = IconInfoText(icon: "video", text: "timelineVideoIconInfo".localize())
    let iconMapInfo = IconInfoText(icon: "map", text: "timelineMapIconInfo".localize())
    let entryHeaderText = InfoHeader(text: "timelineEntryInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let mapLinkText = InfoText(text: "timelineEntryMapLinkInfo".localize())
    let detailInfo = IconInfoText(icon: "magnifyingglass", text: "timelineDetailIconInfo".localize())
    let shareInfo = IconInfoText(icon: "square.and.arrow.up", text: "timelineShareIconInfo".localize())
    let editHeaderText = InfoHeader(text: "timelineInfoEditHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let editText = InfoText(text: "timelineEditInfo".localize())
    let iconEditInfo = IconInfoText(icon: "pencil.circle", text: "timelineEditIconInfo".localize())
    let iconDeleteInfo = IconInfoText(icon: "xmark.circle", text: "timelineDeleteIconInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(headerText)
        stackView.addArrangedSubview(topText)
        stackView.addArrangedSubview(locationText)
        stackView.addArrangedSubview(iconTextInfo)
        stackView.addArrangedSubview(iconImageInfo)
        stackView.addArrangedSubview(iconAudioInfo)
        stackView.addArrangedSubview(iconVideoInfo)
        stackView.addArrangedSubview(iconMapInfo)
        stackView.addArrangedSubview(entryHeaderText)
        stackView.addArrangedSubview(mapLinkText)
        stackView.addArrangedSubview(detailInfo)
        stackView.addArrangedSubview(shareInfo)
        stackView.addArrangedSubview(editHeaderText)
        stackView.addArrangedSubview(editText)
        stackView.addArrangedSubview(iconEditInfo)
        stackView.addArrangedSubview(iconDeleteInfo)
    }
    
    
}