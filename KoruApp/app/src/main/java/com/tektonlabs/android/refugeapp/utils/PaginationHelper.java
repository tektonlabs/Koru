/*
 * ===========================================================================
 * Koru GPL Source Code
 * Copyright (C) 2017 Tekton Labs
 * This file is part of the Koru GPL Source Code.
 * Koru Source Code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Koru Source Code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>.
 * ===========================================================================
 */

package com.tektonlabs.android.refugeapp.utils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class PaginationHelper {

    /***
     *  Receives collection and builds List of lists for local storage
     * @param c Collection containing all of the data to be set as pages
     * @param pageSize
     * @param <T>
     * @return
     */

    public static <T> List<List<T>> getPages(Collection<T> c, Integer pageSize) {
        if (c == null) {
            return Collections.emptyList();
        }

        List<T> list = new ArrayList<T>(c);

        if (pageSize == null || pageSize <= 0 || pageSize > list.size()) {
            pageSize = list.size();
        }
        int numPages = (int) Math.ceil((double) list.size() / (double) pageSize);

        List<List<T>> pages = new ArrayList<List<T>>(numPages);

        for (int pageNum = 0; pageNum < numPages; ) {
            pages.add(list.subList(pageNum * pageSize, Math.min(++pageNum * pageSize, list.size())));
        }
        return pages;
    }

    /***
     * Receives all pages
     * @param pages all pages saved in the local storage
     * @param limit  the total items per page
     * @param offset offset of the current page position
     * @param <T>
     * @return the page at the calculated pageIndex
     */
    public static <T> List<T> getListOfElements(List<List<T>> pages, int limit, int offset) {
        int pageIndex = offset / limit;
        if (offset != 0 && pages.size() <= pageIndex) {
            return Collections.emptyList();
        }
        return pages.get(pageIndex);
    }
}
